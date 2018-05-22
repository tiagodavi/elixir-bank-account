defmodule BankAccount.Server do
  use GenServer

  alias BankAccount.BankAccount

  def start_link(account_id) do
    name = via_tuple(account_id)
    GenServer.start_link(__MODULE__, account_id, name: name)
  end

  def via_tuple(account_id) do
    {:via, Registry, {:bank_account_registry, account_id}}
  end

  def children() do
    DynamicSupervisor.which_children(BankAccountSupervisor)
  end

  def all() do
    children()
    |> Enum.reduce([], fn ({_, pid, :worker, _}, acc) ->
      {:ok, bank_account} = GenServer.call(pid, { :info })
       Enum.concat(acc, [bank_account])
    end)
  end

  def clean() do
    children()
    |> Enum.map(fn({_, pid, :worker, _}) ->
       DynamicSupervisor.terminate_child(BankAccountSupervisor, pid)
    end)
  end

  def init(account_id) do
    {:ok, BankAccount.new(account_id)}
  end

  def handle_call({ :info }, _from, bank_account) do
    state = %BankAccount{ bank_account | amount: Float.round(bank_account.amount, 2)}
    {:reply, {:ok, state}, bank_account}
  end

  def handle_call({ :cash_in, amount }, _from, bank_account) do
    state = %BankAccount{ bank_account | amount: bank_account.amount + amount}
    {:reply, {:ok, Float.round(state.amount, 2)}, state}
  end

  def handle_call({ :cash_out, amount }, _from, bank_account) do
    state = %BankAccount{ bank_account | amount: bank_account.amount - amount}
    {:reply, {:ok, Float.round(state.amount, 2)}, state}
  end

end

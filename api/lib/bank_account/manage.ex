defmodule BankAccount.Manage do

  alias BankAccount.Server

  defguard valid_amount(amount) when is_float(amount) and amount > 0.0

  def all() do
    Server.all()
  end

  def open() do
    account_id = UUID.uuid1()
    DynamicSupervisor.start_child(BankAccountSupervisor, {Server, account_id})
    {:ok, account_id}
  end

  def is_open?(account_id) do
    case Registry.lookup(:bank_account_registry, account_id) do
      [_|_] -> true
      _ -> false
    end
  end

  def transfer!(source_account_id, destination_account_id, amount)
  when valid_amount(amount) do
    cond do

      source_account_id == destination_account_id ->
        {:error, "Source and Destination are the same"}

      is_open?(source_account_id) &&
      is_open?(destination_account_id) ->

        {:ok, balance} = balance(source_account_id)

        if(balance >= amount) do
          {:ok, source_balance} = GenServer.call(Server.via_tuple(source_account_id), { :cash_out, amount })
          {:ok, destination_balance} = GenServer.call(Server.via_tuple(destination_account_id), { :cash_in, amount })
          {:ok, source_balance, destination_balance}
        else
          {:error, "There is no balance enough"}
        end

      true ->
        {:error, "Bank account (source or destination) not found"}
    end
  end
  def transfer!(_,_,_), do: {:error, "Invalid Amount"}

  def balance(account_id) do
    if is_open?(account_id) do
      {:ok, bank_account} = GenServer.call(Server.via_tuple(account_id), { :info })
      {:ok, bank_account.amount}
    else
      {:error, "Bank account not found"}
    end
  end

  def clean() do
    Server.clean()
  end

end

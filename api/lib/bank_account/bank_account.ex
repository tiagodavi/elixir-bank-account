defmodule BankAccount.BankAccount do
  defstruct [account_id: "", amount: 50.0]

  def new(account_id) do
    %BankAccount.BankAccount{
      account_id: account_id
    }
  end
end

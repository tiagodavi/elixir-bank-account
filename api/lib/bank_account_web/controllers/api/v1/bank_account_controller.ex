defmodule BankAccountWeb.Api.V1.BankAccountController do
  use BankAccountWeb, :controller

  alias BankAccount.Manage

  def index(conn, _params) do
    render conn, "index.json", %{bank_accounts: Manage.all()}
  end

  def open(conn, _params) do
    case Manage.open() do
      {:ok, account_id} ->
        render conn, "open.json", %{account_id: account_id}
      _ ->
        render conn, "error.json", %{error: "Unable to open a new bank account"}
    end
  end

  def balance(conn, %{"account_id" => account_id}) do
    case Manage.balance(account_id) do
      {:ok, balance} ->
        render conn, "balance.json", %{balance: balance}
      {:error, error} ->
        render conn, "error.json", %{error: error}
    end
  end

  def transfer(conn, params) do
    {amount, _} = Float.parse(params["amount"])
    case Manage.transfer!(
      params["source_account_id"],
      params["destination_account_id"],
      amount) do
      {:ok, source_balance, destination_balance} ->
        render conn, "transfer.json", %{source_balance: source_balance, destination_balance: destination_balance}
      {:error, error} ->
        render conn, "error.json", %{error: error}
    end
  end

end

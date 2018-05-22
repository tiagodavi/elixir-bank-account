defmodule BankAccountWeb.Api.V1.BankAccountView do
  use BankAccountWeb, :view

  alias BankAccount.BankAccount

  def render("error.json", %{error: error}) do
    %{error: error}
  end

  def render("index.json", %{bank_accounts: bank_accounts}) do
    %{bank_accounts: bank_accounts}
  end

  def render("open.json", %{account_id: account_id}) do
    %{account_id: account_id}
  end

  def render("balance.json", %{balance: balance}) do
    %{balance: balance}
  end

  def render("transfer.json", %{source_balance: source_balance, destination_balance: destination_balance}) do
    %{source_balance: source_balance, destination_balance: destination_balance}
  end

end

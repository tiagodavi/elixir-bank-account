defmodule BankAccountWeb.Router do
  use BankAccountWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankAccountWeb, as: :api do
    pipe_through :api
    scope "/v1", Api.V1, as: :v1 do
      scope "/bank-accounts" do
        get "/", BankAccountController, :index
        post "/open", BankAccountController, :open
        get "/balance/:account_id", BankAccountController, :balance
        put "/transfer/:source_account_id/:destination_account_id/:amount", BankAccountController, :transfer
      end
    end
  end
end

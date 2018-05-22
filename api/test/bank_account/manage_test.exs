defmodule BankAccount.ManageTest do
  use ExUnit.Case, async: true

  alias BankAccount.Manage

  setup do
    Manage.clean()
    :ok
  end

  test ".is_open? returns false when when account_id is invalid" do
    response = Manage.is_open?(00000)
    assert response == false
  end

  test ".is_open? returns true when when account_id is valid" do
    {:ok, account_id} = Manage.open()
    assert Manage.is_open?(account_id) == true
  end

  test ".balance returns - Bank account not found - when account_id is invalid" do
    {:error, error} = Manage.balance(0000)
    assert error == "Bank account not found"
  end

  test ".balance returns amount when account_id is valid" do
    {:ok, account_id} = Manage.open()
    {:ok, balance} = Manage.balance(account_id)
    assert balance == 50.0
  end

  test ".transfer! returns - Invalid Amount - when amount is invalid" do
    {:error, error} = Manage.transfer!(0,0,15)
    assert error == "Invalid Amount"
  end

  test ".transfer! returns - Source and Destination are the same - when they are equal" do
    {:ok, source} = Manage.open()
    {:error, error} = Manage.transfer!(source,source,7.5)
    assert error == "Source and Destination are the same"
  end

  test ".transfer! returns - Bank account (source or destination) not found - when one of them is not found" do
    {:ok, source} = Manage.open()
    {:error, error} = Manage.transfer!(source,0000,7.5)
    assert error == "Bank account (source or destination) not found"
  end

  test ".transfer! returns - There is no balance enough - when one of them has no balance to transfer" do
    {:ok, source} = Manage.open()
    {:ok, destination} = Manage.open()
    {:error, error} = Manage.transfer!(source,destination,60.0)
    assert error == "There is no balance enough"
  end

  test ".transfer! returns a tuple when is able to transfer" do
    {:ok, source} = Manage.open()
    {:ok, destination} = Manage.open()
    {:ok, source_balance, destination_balance} = Manage.transfer!(source,destination,10.5)
    assert source_balance == 39.5
    assert destination_balance == 60.5
  end

  test ".all returns an empty list when there are no bank accounts" do
    response = Manage.all()
    assert response == []
  end

  test ".all returns all opened bank accounts" do
    Manage.open()
    Manage.open()

    total = Manage.all()
    |> Enum.count()

    assert total == 2
  end

end

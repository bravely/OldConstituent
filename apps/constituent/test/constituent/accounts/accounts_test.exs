defmodule Constituent.AccountsTest do
  use Constituent.DataCase

  alias Constituent.Accounts

  describe "users" do
    alias Constituent.Accounts.User

    @valid_attrs %{address_one: "some address_one", address_two: "some address_two", city: "some city", email: "some email", password: "some password_hash", state: "some state", username: "some username", zip: "some zip"}
    @update_attrs %{address_one: "some updated address_one", address_two: "some updated address_two", city: "some updated city", email: "some updated email", password: "some updated password_hash", state: "some updated state", username: "some updated username", zip: "some updated zip"}
    @invalid_attrs %{address_one: nil, address_two: nil, city: nil, email: nil, state: nil, username: nil, zip: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      %{user | password: nil}
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.address_one == "some address_one"
      assert user.address_two == "some address_two"
      assert user.city == "some city"
      assert user.email == "some email"
      assert user.password_hash
      assert user.state == "some state"
      assert user.username == "some username"
      assert user.zip == "some zip"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.address_one == "some updated address_one"
      assert user.address_two == "some updated address_two"
      assert user.city == "some updated city"
      assert user.email == "some updated email"
      assert user.password_hash
      assert user.state == "some updated state"
      assert user.username == "some updated username"
      assert user.zip == "some updated zip"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end

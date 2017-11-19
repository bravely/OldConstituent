defmodule Constituent.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.Accounts.User


  schema "users" do
    field :address_1, :string
    field :address_2, :string
    field :city, :string
    field :email, :string
    field :password_hash, :string
    field :state, :string
    field :username, :string
    field :zip, :string

    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :zip, :state, :city, :address_1, :address_2])
    |> hash_password
    |> validate_required([:email, :username, :password_hash, :zip, :state, :city, :address_1, :address_2])
    |> unique_constraint(:email)
  end

  def hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Argon2.hashpwsalt(pass))
      _ -> changeset
    end
  end
end

defmodule Constituent.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.Accounts.User


  schema "users" do
    field :address_one, :string
    field :address_two, :string
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
    |> cast(attrs, [:email, :username, :password, :zip, :state, :city, :address_one, :address_two])
    |> validate_length(:password, min: 6)
    |> hash_password
    |> validate_required([:email, :username, :zip, :state, :city, :address_one])
    |> unsafe_validate_unique([:email], Constituent.Repo)
    |> unique_constraint(:email)
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Argon2.hashpwsalt(pass))
      _ -> changeset
    end
  end
end

defmodule Constituent.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string
      add :password_hash, :string
      add :zip, :string
      add :state, :string
      add :city, :string
      add :address_1, :string
      add :address_2, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end

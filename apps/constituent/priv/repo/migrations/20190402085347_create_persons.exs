defmodule Constituent.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :name, :string
      add :date_of_birth, :utc_datetime
      add :short_biography, :string
      add :biography, :text
      add :national_identity, :string

      timestamps()
    end

  end
end

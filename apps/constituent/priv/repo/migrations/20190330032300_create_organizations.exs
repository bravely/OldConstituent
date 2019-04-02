defmodule Constituent.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :short_description, :string
      add :description, :text
      add :area_id, references(:areas, on_delete: :nothing)
      add :classification, :string

      timestamps()
    end

    create index(:organizations, [:area_id])
  end
end

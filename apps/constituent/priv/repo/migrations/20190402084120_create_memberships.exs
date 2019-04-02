defmodule Constituent.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :label, :string
      add :role, :string
      add :organization_id, references(:organizations, on_delete: :nothing)
      add :area_id, references(:areas, on_delete: :nothing)

      timestamps()
    end

    create index(:memberships, [:organization_id])
    create index(:memberships, [:area_id])
  end
end

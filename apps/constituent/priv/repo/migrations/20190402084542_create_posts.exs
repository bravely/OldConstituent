defmodule Constituent.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :label, :string
      add :function, :string
      add :organization_id, references(:organizations, on_delete: :nothing)
      add :area_id, references(:areas, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:organization_id])
    create index(:posts, [:area_id])
  end
end

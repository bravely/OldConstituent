defmodule Constituent.Repo.Migrations.CreateGeomes do
  use Ecto.Migration

  def change do
    create table(:geomes) do
      add :area_id, references(:areas, on_delete: :nothing)

      timestamps()
    end
    execute "SELECT AddGeometryColumn ('geomes', 'boundaries', 4269, 'MULTIPOLYGON', 2)"

    create index(:geomes, [:area_id])
    create index(:geomes, [:boundaries], using: "GIST")

    alter table(:areas) do
      remove(:boundaries)
    end
  end
end

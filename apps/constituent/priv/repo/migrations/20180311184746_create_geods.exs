defmodule Constituent.Repo.Migrations.CreateAreas do
  use Ecto.Migration

  def up do
    create unique_index(:us_states, [:usps])

    create table(:areas) do
      add :us_state_usps, references(:us_states, column: :usps, type: :string, on_delete: :nothing)
      add :district_id, references(:districts, on_delete: :nothing)

      timestamps()
    end
    execute "SELECT AddGeometryColumn ('areas', 'center', 4269, 'POINT', 2)"
    execute "SELECT AddGeometryColumn ('areas', 'boundaries', 4269, 'MULTIPOLYGON', 2)"

    create unique_index(:areas, [:us_state_usps])
    create unique_index(:areas, [:district_id])
    create index(:areas, [:boundaries], using: "GIST")
  end

  def down do
    drop table(:areas)
    drop unique_index(:us_states, [:usps])
  end
end

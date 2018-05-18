defmodule Constituent.Repo.Migrations.RemoveGeoFromPoliticalEntities do
  use Ecto.Migration

  def up do
    alter table(:us_states) do
      remove :center
      remove :boundaries
    end

    alter table(:districts) do
      remove :center
      remove :boundaries
    end
  end

  def down do
    execute "SELECT AddGeometryColumn ('us_states', 'center', 4269, 'POINT', 2)"
    execute "SELECT AddGeometryColumn ('us_states', 'boundaries', 4269, 'MULTIPOLYGON', 2)"

    create index(:us_states, [:boundaries], using: "GIST")

    execute "SELECT AddGeometryColumn ('districts', 'center', 4269, 'POINT', 2)"
    execute "SELECT AddGeometryColumn ('districts', 'boundaries', 4269, 'MULTIPOLYGON', 2)"

    create index(:districts, [:boundaries], using: "GIST")
  end
end

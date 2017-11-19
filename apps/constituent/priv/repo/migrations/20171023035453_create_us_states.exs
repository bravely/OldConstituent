defmodule Constituent.Repo.Migrations.CreateUsStates do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    create table(:us_states) do
      add :name, :string
      add :region, :integer
      add :fips, :integer
      add :usps, :string
      add :division, :integer

      timestamps()
    end

    execute "SELECT AddGeometryColumn ('us_states', 'center', 4269, 'POINT', 2)"
    execute "SELECT AddGeometryColumn ('us_states', 'boundaries', 4269, 'MULTIPOLYGON', 2)"

    create index(:us_states, [:boundaries], using: "GIST")
  end

  def down do
    drop table(:us_states)

    execute "DROP EXTENSION IF EXISTS postgis"
  end
end

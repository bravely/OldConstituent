defmodule Constituent.Repo.Migrations.CreateDistricts do
  use Ecto.Migration

  def up do
    create table(:districts) do
      add :name, :string
      add :number_of_seats, :integer
      add :open_states_uid, :string
      add :us_state_fips, references(:us_states, column: :fips, type: :integer, on_delete: :nothing)
      add :government, :string
      add :chamber, :string
      add :identifier, :string

      timestamps()
    end
    execute "SELECT AddGeometryColumn ('districts', 'center', 4269, 'POINT', 2)"
    execute "SELECT AddGeometryColumn ('districts', 'boundaries', 4269, 'MULTIPOLYGON', 2)"

    create index(:districts, [:boundaries], using: "GIST")
    create unique_index(:districts, [:us_state_fips, :identifier, :chamber, :government])
  end

  def down do
    drop table(:districts)
  end
end

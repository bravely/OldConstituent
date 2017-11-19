defmodule Constituent.Repo.Migrations.CreateDistricts do
  use Ecto.Migration

  def change do
    create table(:districts) do
      add :name, :string
      add :number_of_seats, :integer
      add :open_states_uid, :string
      add :us_state_id, references(:us_states, on_delete: :nothing)
      add :government, :string
      add :chamber, :string

      timestamps()
    end
    execute "SELECT AddGeometryColumn ('districts', 'center', 4269, 'POINT', 2)"
    execute "SELECT AddGeometryColumn ('districts', 'boundaries', 4269, 'MULTIPOLYGON', 2)"

    create index(:districts, [:us_state_id])
  end
end

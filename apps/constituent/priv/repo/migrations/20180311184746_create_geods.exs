defmodule Constituent.Repo.Migrations.CreateGeods do
  use Ecto.Migration

  def up do
    create(unique_index(:us_states, [:usps]))

    create table(:geods) do
      add(
        :us_state_usps,
        references(:us_states, column: :usps, type: :string, on_delete: :nothing)
      )

      add(:district_id, references(:districts, on_delete: :nothing))

      timestamps()
    end

    execute("SELECT AddGeometryColumn ('geods', 'center', 4269, 'POINT', 2)")
    execute("SELECT AddGeometryColumn ('geods', 'boundaries', 4269, 'MULTIPOLYGON', 2)")

    create(unique_index(:geods, [:us_state_usps]))
    create(unique_index(:geods, [:district_id]))
    create(index(:geods, [:boundaries], using: "GIST"))
  end

  def down do
    drop(table(:geods))
    drop(unique_index(:us_states, [:usps]))
  end
end

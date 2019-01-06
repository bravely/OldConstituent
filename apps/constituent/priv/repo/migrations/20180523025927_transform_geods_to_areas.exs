defmodule Constituent.Repo.Migrations.TransformGeodsToAreas do
  use Ecto.Migration

  def change do
    rename(table(:geods), to: table(:areas))

    alter table(:areas) do
      add(:name, :string)
      add(:identifier, :string)
      add(:classification, :string)
      add(:parent_area_id, references(:areas, on_delete: :nothing))
    end
  end
end

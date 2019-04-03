defmodule Constituent.Repo.Migrations.AddCodesToAreas do
  use Ecto.Migration

  def change do
    alter table(:areas) do
      remove :center
      remove :us_state_usps
      remove :district_id
      add :codes, :jsonb
    end
  end
end

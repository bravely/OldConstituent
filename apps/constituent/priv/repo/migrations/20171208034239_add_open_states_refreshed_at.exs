defmodule Constituent.Repo.Migrations.AddOpenStatesRefreshedAt do
  use Ecto.Migration

  def change do
    alter table(:districts) do
      add :open_states_refreshed_at, :utc_datetime
    end

    alter table(:us_states) do
      add :open_states_refreshed_at, :utc_datetime
    end
  end
end

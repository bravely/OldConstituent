defmodule Mix.Tasks.Constituent.Geod.MigrateTo do
  @moduledoc """
  Moves data from being directly on the relevant UsState/District to
  the relevant Geod row.
  """
  use Mix.Task
  import Ecto.Query

  alias Constituent.{
    Repo,
    PoliticalEntities,
    PoliticalEntities.UsState,
    PoliticalEntities.District,
    PoliticalEntities.Geod
  }

  @shortdoc "Moves data from being directly on the relevant UsState/District to
  the relevant Geod row."
  def run([]) do
    Mix.Task.run("app.start", [])

    Repo.transaction(fn() ->
      stream_geod_migration(UsState)
      stream_geod_migration(District)
    end, timeout: :infinity)
  end

  def stream_geod_migration(query) do
    query
    |> Repo.stream
    |> Stream.chunk_every(10)
    |> Task.async_stream(&migrate_to_geods/1, timeout: 60_000)
    |> Stream.run
  end

  def migrate_to_geods(political_entities) do
    Enum.each(political_entities, &migrate_to_geod/1)
  end

  def migrate_to_geod(%UsState{usps: usps} = us_state) do
    case Repo.one(from g in Geod, where: g.us_state_usps == ^usps) do
      nil -> PoliticalEntities.create_geod(%{us_state_usps: usps, center: us_state.center, boundaries: us_state.boundaries})
      geod -> PoliticalEntities.update_geod(geod, %{center: us_state.center, boundaries: us_state.boundaries})
    end
  end
  def migrate_to_geod(%District{} = district) do
    case Repo.one(from g in Geod, where: g.district_id == ^district.id) do
      nil -> PoliticalEntities.create_geod(%{district_id: district.id, center: district.center, boundaries: district.boundaries})
      geod -> PoliticalEntities.update_geod(geod, %{center: district.center, boundaries: district.boundaries})
    end
  end
end

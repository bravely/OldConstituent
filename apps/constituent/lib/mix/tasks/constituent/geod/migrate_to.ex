defmodule Mix.Tasks.Constituent.Area.MigrateTo do
  @moduledoc """
  Moves data from being directly on the relevant UsState/District to
  the relevant Area row.
  """
  use Mix.Task
  import Ecto.Query

  alias Constituent.{
    Repo,
    PoliticalEntities,
    PoliticalEntities.UsState,
    PoliticalEntities.District,
    PoliticalEntities.Area
  }

  @shortdoc "Moves data from being directly on the relevant UsState/District to
  the relevant Area row."
  def run([]) do
    Mix.Task.run("app.start", [])

    Repo.transaction(fn() ->
      stream_area_migration(UsState)
      stream_area_migration(District)
    end, timeout: :infinity)
  end

  def stream_area_migration(query) do
    query
    |> Repo.stream
    |> Stream.chunk_every(10)
    |> Task.async_stream(&migrate_to_areas/1, timeout: 60_000)
    |> Stream.run
  end

  def migrate_to_areas(political_entities) do
    Enum.each(political_entities, &migrate_to_area/1)
  end

  def migrate_to_area(%UsState{usps: usps} = us_state) do
    case Repo.one(from g in Area, where: g.us_state_usps == ^usps) do
      nil -> PoliticalEntities.create_area(%{us_state_usps: usps, center: us_state.center, boundaries: us_state.boundaries})
      area -> PoliticalEntities.update_area(area, %{center: us_state.center, boundaries: us_state.boundaries})
    end
  end
  def migrate_to_area(%District{} = district) do
    case Repo.one(from g in Area, where: g.district_id == ^district.id) do
      nil -> PoliticalEntities.create_area(%{district_id: district.id, center: district.center, boundaries: district.boundaries})
      area -> PoliticalEntities.update_area(area, %{center: district.center, boundaries: district.boundaries})
    end
  end
end

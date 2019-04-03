defmodule Researcher.Census.Harvest.UsStates do
  alias Constituent.PoliticalEntities

  def harvest_us_states(path) do
    [{_name, _proj, stream}] = ShapeShift.from_zip(path, srid: 4269)

    stream
    |> Flow.from_enumerable
    |> Flow.map(&to_us_state_area/1)
    |> Enum.to_list
  end

  def to_us_state_area(%{attributes: %{"NAME" => raw_name}} = us_state_row) do
    raw_name
    |> String.trim
    |> PoliticalEntities.find_area_by_name()
    |> case do
      %PoliticalEntities.Area{} = area ->
        PoliticalEntities.update_us_state_area(area, us_state_row)
      nil ->
        PoliticalEntities.create_us_state_area(us_state_row)
    end
  end
end

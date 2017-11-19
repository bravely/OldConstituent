defmodule Researcher.Census.GeoStates do
  alias Constituent.{Repo, PoliticalEntities}
  alias Constituent.PoliticalEntities.UsState

  import Researcher.Census, only: [download_directory: 1]

  def download_us_states do
    [path] = download_directory("geo/tiger/TIGER2017/STATE/")

    [{_name, _proj, stream}] = ShapeShift.from_zip(path, srid: 4269)

    stream
    |> Flow.from_enumerable
    |> Flow.map(&to_us_state/1)
    |> Enum.to_list
  end

  defp to_us_state(%{attributes: %{"STUSPS" => usps}} = us_state_row) do
    case PoliticalEntities.get_us_state_by(usps: usps) do
      %PoliticalEntities.UsState{} = us_state ->
        PoliticalEntities.update_us_state(us_state, us_state_attrs(us_state_row))
      nil ->
        PoliticalEntities.create_us_state(us_state_attrs(us_state_row))
    end
  end

  defp us_state_attrs(%{attributes: attributes, geometry: geometry}) do
    %{
      name: attributes["NAME"] |> String.trim,
      usps: attributes["STUSPS"],
      fips: attributes["STATEFP"],
      division: attributes["DIVISION"] |> String.trim |> String.to_integer,
      region: attributes["REGION"] |> String.trim |> String.to_integer,
      center: %Geo.Point{coordinates: {
        attributes["INTPTLON"] |> String.to_float,
        attributes["INTPTLAT"] |> String.to_float
      }, srid: 4269},
      boundaries: geometry
    }
  end
end

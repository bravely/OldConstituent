defmodule Researcher.Census.GeoSldu do
  alias Constituent.PoliticalEntities

  def harvest do
    ~r/tl_2017_\d+_sldu.zip/
    |> Researcher.filter_downloads
    |> Flow.from_enumerable
    |> Flow.map(fn(path) ->
      ShapeShift.from_zip("downloads/#{path}", srid: 4269)
    end)
    |> Flow.each(&process_district_stream/1)
    |> Flow.run
  end

  defp process_district_stream([{_name, _proj, stream}]) do
    stream
    |> Flow.from_enumerable
    |> Flow.each(&to_district/1)
    |> Flow.run
  end

  defp to_district(%{attributes: %{"SLDUST" => identifier}} = district_row) do
    district_attrs = census_attrs(district_row)
    case PoliticalEntities.get_district_by(identifier: identifier) do
      %PoliticalEntities.District{} = district ->
        PoliticalEntities.update_district(district, district_attrs)
      nil ->
        PoliticalEntities.create_district(district_attrs)
    end
  end

  defp census_attrs(%{attributes: attributes, geometry: geometry}) do
    %{
      name: String.trim(attributes["NAMELSAD"]),
      identifier: attributes["SLDUST"],
      geod: %{
        center: %Geo.Point{coordinates: {
          attributes["INTPTLON"] |> String.to_float,
          attributes["INTPTLAT"] |> String.to_float
        }, srid: 4269},
        boundaries: geometry,
      },
      us_state_id: PoliticalEntities.get_us_state_by(fips: attributes["STATEFP"]).id,
      government: "state",
      chamber: "upper"
    }
  end
end

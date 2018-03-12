defmodule Researcher.Census.GeoStateDistrict do
  alias Constituent.PoliticalEntities

  def harvest_all(:lower) do
    harvest_shapefiles(~r/tl_2017_\d+_sldl.zip/)
  end
  def harvest_all(:upper) do
    harvest_shapefiles(~r/tl_2017_\d+_sldu.zip/)
  end

  defp harvest_shapefiles(shapefile_regex) do
    shapefile_regex
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

  defp to_district(district_row) do
    district_attrs = census_attrs(district_row)
    case get_matching_district(district_attrs) do
      %PoliticalEntities.District{} = district ->
        {:ok, _d} = PoliticalEntities.update_district(district, district_attrs)
      nil ->
        {:ok, _d} = PoliticalEntities.create_district(district_attrs)
    end
  end

  def census_attrs(%{attributes: attributes, geometry: geometry}) do
    %{
      name: String.trim(attributes["NAMELSAD"]),
      geod: %{
        center: %Geo.Point{coordinates: {
          attributes["INTPTLON"] |> String.to_float,
          attributes["INTPTLAT"] |> String.to_float
        }, srid: 4269},
        boundaries: geometry,
      },
      us_state_fips: String.to_integer(attributes["STATEFP"]),
      government: "state",
    }
    |> Map.merge(identifier_attrs(attributes))
  end

  defp identifier_attrs(%{"SLDLST" => identifier}) do
    %{
      identifier: identifier,
      chamber: "lower"
    }
  end
  defp identifier_attrs(%{"SLDUST" => identifier}) do
    %{
      identifier: identifier,
      chamber: "upper"
    }
  end

  defp get_matching_district(district_attrs) do
    PoliticalEntities.get_district_by(
      identifier: district_attrs.identifier,
      us_state_fips: district_attrs.us_state_fips,
      chamber: district_attrs.chamber,
      government: district_attrs.government
    )
  end
end

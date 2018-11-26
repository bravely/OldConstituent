defmodule Researcher.Census.GeoSld do
  alias Constituent.PoliticalEntities

  def harvest_sldu do
    harvest_for_chamber(~r/tl_2017_\d+_sldu.zip/, "upper")
  end

  def harvest_sldl do
    harvest_for_chamber(~r/tl_2017_\d+_sldl.zip/, "lower")
  end

  defp harvest_for_chamber(file_regex, chamber) do
    file_regex
    |> Researcher.filter_downloads
    |> Flow.from_enumerable
    |> Flow.map(fn(path) ->
      ShapeShift.from_zip("downloads/#{path}", srid: 4269)
    end)
    |> Flow.each(&(process_district_stream(&1, chamber)))
    |> Flow.run
  end

  defp process_district_stream([{_name, _proj, stream}], chamber) do
    stream
    |> Flow.from_enumerable
    |> Flow.each(&(to_district(&1, chamber)))
    |> Flow.run
  end

  defp to_district(district_row, chamber) do
    case get_district_by_census_attrs(district_row, chamber) do
      %PoliticalEntities.District{} = district ->
        PoliticalEntities.update_district(district, census_attrs(district_row, chamber, district.area))
      nil ->
        PoliticalEntities.create_district(census_attrs(district_row, chamber))
    end
  end

  defp census_attrs(%{attributes: attributes, geometry: geometry}, chamber, area \\ %{}) do
    %{
      name: String.trim(attributes["NAMELSAD"]),
      identifier: attributes[identifier_field(chamber)],
      area: %{
        id: Map.get(area, :id),
        center: %Geo.Point{coordinates: {
          attributes["INTPTLON"] |> String.to_float,
          attributes["INTPTLAT"] |> String.to_float
        }, srid: 4269},
        boundaries: geometry,
      },
      us_state_fips: PoliticalEntities.get_us_state_by(fips: attributes["STATEFP"]).fips,
      government: "state",
      chamber: chamber
    }
  end

  defp identifier_field("upper") do
    "SLDUST"
  end
  defp identifier_field("lower") do
    "SLDLST"
  end

  def get_district_by_census_attrs(census_row, chamber) do
    census_row
    |> census_attrs(chamber)
    |> Map.drop([:area])
    |> Enum.into([])
    |> PoliticalEntities.get_district_with_area_by
  end
end

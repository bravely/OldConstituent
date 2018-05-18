defmodule Researcher.Census.GeoCongressionalDistrict do
  alias Constituent.PoliticalEntities

  def harvest_all do
    [{_name, _proj, stream}] = ShapeShift.from_zip("downloads/tl_2017_us_cd115.zip", srid: 4269)

    stream
    |> Flow.from_enumerable
    |> Flow.each(&harvest_congressional_district/1)
    |> Flow.run
  end

  defp harvest_congressional_district(district_row) do
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
      identifier: attributes["CD115FP"],
      geod: %{
        center: %Geo.Point{coordinates: {
          attributes["INTPTLON"] |> String.to_float,
          attributes["INTPTLAT"] |> String.to_float
        }, srid: 4269},
        boundaries: geometry,
      },
      us_state_fips: String.to_integer(attributes["STATEFP"]),
      government: "federal",
      chamber: "lower"
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

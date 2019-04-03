defmodule Constituent.PoliticalEntities.Area do
  use Constituent, :data_handling

  alias Constituent.PoliticalEntities.{
    Area,
    Geome
  }


  schema "areas" do
    field :name, :string
    field :identifier, :string
    field :classification, :string
    field :codes, :map, default: %{}

    belongs_to :parent_area, Area
    has_one :geome, Geome

    timestamps()
  end

  @doc false
  def changeset(%Area{} = area, attrs) do
    area
    |> cast(attrs, [:name, :identifier, :classification, :codes, :parent_area_id])
    |> validate_required([:name, :identifier, :classification, :codes])
  end

  def intake_census_state(%{attributes: attributes, geometry: geometry}) do
    %{
      name: String.trim(attributes["NAME"]),
      identifier: attributes["STUSPS"],
      classification: "US State",
      codes: %{
        "USPS" => attributes["STUSPS"],
        "FIPS" => attributes["STATEFP"],
        "region" => attributes["REGION"] |> String.trim |> String.to_integer(),
        "division" => attributes["DIVISION"] |> String.trim |> String.to_integer()
      },
      geome: %{
        boundaries: geometry
      }
    }
  end
end

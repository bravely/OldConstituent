defmodule Constituent.PoliticalEntities.Area do
  use Constituent, :data_handling

  alias Constituent.PoliticalEntities.Area


  schema "areas" do
    field :name, :string
    field :identifier, :string
    field :classification, :string
    field :center, Geo.Point
    field :boundaries, Geo.MultiPolygon

    belongs_to :us_state, Constituent.PoliticalEntities.UsState, foreign_key: :us_state_usps, references: :usps, type: :string
    belongs_to :district, Constituent.PoliticalEntities.District

    belongs_to :parent_area, Area

    timestamps()
  end

  @doc false
  def changeset(%Area{} = area, attrs) do
    area
    |> cast(attrs, [:name, :identifier, :classification, :parent_area_id, :us_state_usps, :district_id, :center, :boundaries])
    |> Support.Ecto.validate_required_inclusion([:us_state_usps, :district_id])
    |> validate_required([:boundaries])
  end
end

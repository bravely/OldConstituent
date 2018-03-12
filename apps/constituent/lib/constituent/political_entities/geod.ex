defmodule Constituent.PoliticalEntities.Geod do
  use Constituent, :data_handling

  alias Constituent.PoliticalEntities.Geod


  schema "geods" do
    field :center, Geo.Point
    field :boundaries, Geo.MultiPolygon

    belongs_to :us_state, Constituent.PoliticalEntities.UsState, foreign_key: :us_state_usps, references: :usps, type: :string
    belongs_to :district, Constituent.PoliticalEntities.District

    timestamps()
  end

  @doc false
  def changeset(%Geod{} = geod, attrs) do
    geod
    |> cast(attrs, [:us_state_usps, :district_id, :center, :boundaries])
    |> Support.Ecto.validate_required_inclusion([:us_state_usps, :district_id])
    |> validate_required([:boundaries])
  end
end

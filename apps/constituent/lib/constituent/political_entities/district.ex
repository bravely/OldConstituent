defmodule Constituent.PoliticalEntities.District do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.PoliticalEntities.District


  schema "districts" do
    field :name, :string
    field :number_of_seats, :integer
    field :open_states_uid, :string
    field :us_state_id, :id
    field :government, :string
    field :chamber, :string
    field :center, Geo.Point
    field :boundaries, Geo.MultiPolygon

    timestamps()
  end

  @doc false
  def changeset(%District{} = district, attrs) do
    district
    |> cast(attrs, [:name, :number_of_seats, :open_states_uid, :us_state_id, :government, :chamber, :center, :boundaries])
    |> validate_required([:name, :us_state_id, :government, :chamber])
    |> validate_inclusion(:government, ["federal", "state"])
    |> validate_inclusion(:chamber, ["upper", "lower"])
  end
end

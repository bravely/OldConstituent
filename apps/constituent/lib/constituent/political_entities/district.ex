defmodule Constituent.PoliticalEntities.District do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.PoliticalEntities.District


  schema "districts" do
    field :name, :string
    field :number_of_seats, :integer
    field :open_states_uid, :string
    field :government, :string
    field :chamber, :string
    field :identifier, :string
    field :open_states_refreshed_at, :utc_datetime

    belongs_to :us_state, Constituent.PoliticalEntities.UsState, foreign_key: :us_state_fips, references: :fips, type: :integer
    has_one :geod, Constituent.PoliticalEntities.Geod, foreign_key: :district_id

    timestamps()
  end

  @doc false
  def changeset(%District{} = district, attrs) do
    district
    |> cast(attrs, [:name, :number_of_seats, :open_states_uid, :us_state_fips, :government, :chamber, :identifier])
    |> cast_assoc(:geod)
    |> validate_required([:name, :identifier, :us_state_fips, :government, :chamber])
    |> validate_inclusion(:government, ["federal", "state"])
    |> validate_inclusion(:chamber, ["upper", "lower"])
    |> unique_constraint(:identifier, name: :districts_us_state_fips_identifier_chamber_government_index)
  end
end

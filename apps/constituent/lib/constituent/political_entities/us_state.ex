defmodule Constituent.PoliticalEntities.UsState do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  import Geo.PostGIS
  alias Constituent.Repo
  alias Constituent.PoliticalEntities.UsState


  schema "us_states" do
    field :division, :integer
    field :fips, :integer
    field :name, :string
    field :region, :integer
    field :usps, :string
    field :center, Geo.Point
    field :boundaries, Geo.MultiPolygon
    field :open_states_refreshed_at, :utc_datetime

    has_many :districts, Constituent.PoliticalEntities.District, foreign_key: :us_state_fips, references: :fips
    has_one :geod, Constituent.PoliticalEntities.Geod, foreign_key: :us_state_usps, references: :usps

    timestamps()
  end

  @doc false
  def changeset(%UsState{} = us_state, attrs) do
    us_state
    |> cast(attrs, [:name, :region, :fips, :usps, :division, :center, :boundaries])
    |> cast_assoc(:geod)
    |> validate_required([:name, :region, :fips, :usps, :division])
    |> unsafe_validate_unique([:fips], Repo)
    |> unsafe_validate_unique([:usps], Repo)
    |> unique_constraint(:fips)
    |> unique_constraint(:usps)
  end

  def performant_query(center) do
    Repo.all(from u in Constituent.PoliticalEntities.UsState, where: fragment("(?) && (?)", u.boundaries, ^center) and st_contains(u.boundaries, ^center))
  end
end

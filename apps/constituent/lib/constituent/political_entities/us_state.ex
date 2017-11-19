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

    timestamps()
  end

  @doc false
  def changeset(%UsState{} = us_state, attrs) do
    us_state
    |> cast(attrs, [:name, :region, :fips, :usps, :division, :center, :boundaries])
    |> validate_required([:name, :region, :fips, :usps, :division, :center, :boundaries])
  end

  def performant_query(center) do
    Repo.all(from u in Constituent.PoliticalEntities.UsState, where: fragment("(?) && (?)", u.boundaries, ^center) and st_contains(u.boundaries, ^center))
  end
end

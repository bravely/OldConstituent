defmodule Constituent.PoliticalEntities.Geome do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.PoliticalEntities.{
    Geome,
    Area
  }


  schema "geomes" do
    belongs_to :area, Area
    field :boundaries, Geo.MultiPolygon

    timestamps()
  end

  @doc false
  def changeset(%Geome{} = geome, attrs) do
    geome
    |> cast(attrs, [:area_id, :boundaries])
    |> validate_required([:area_id, :boundaries])
  end
end

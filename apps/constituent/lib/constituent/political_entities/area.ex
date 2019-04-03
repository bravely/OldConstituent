defmodule Constituent.PoliticalEntities.Area do
  use Constituent, :data_handling

  alias Constituent.{
    PoliticalEntities.Area,
    Geomes
  }


  schema "areas" do
    field :name, :string
    field :identifier, :string
    field :classification, :string
    field :codes, :map, default: %{}

    belongs_to :parent_area, Area
    has_one :geomes, Geomes.Geome

    timestamps()
  end

  @doc false
  def changeset(%Area{} = area, attrs) do
    area
    |> cast(attrs, [:name, :identifier, :classification, :codes, :parent_area_id])
    |> validate_required([:name, :identifier, :classification, :codes])
  end
end

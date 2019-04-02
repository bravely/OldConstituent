defmodule Constituent.Orgs.Organization do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.{
    Orgs.Organization,
    PoliticalEntities.Area
  }

  schema "organizations" do
    field :description, :string
    field :name, :string
    field :short_description, :string
    field :classification, :string
    belongs_to :area, Area

    timestamps()
  end

  @doc false
  def changeset(%Organization{} = organization, attrs) do
    organization
    |> cast(attrs, [:name, :short_description, :description])
    |> validate_required([:name, :short_description, :description])
  end
end

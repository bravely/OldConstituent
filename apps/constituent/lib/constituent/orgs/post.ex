defmodule Constituent.Orgs.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.Orgs.Post
  alias Constituent.PoliticalEntities

  schema "posts" do
    field :function, :string
    field :label, :string
    field :organization_id, :id
    belongs_to :area, PoliticalEntities.Area

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:label, :function])
    |> validate_required([:label, :function])
  end
end

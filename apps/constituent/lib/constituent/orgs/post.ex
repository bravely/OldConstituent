defmodule Constituent.Orgs.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.Orgs.Post


  schema "posts" do
    field :function, :string
    field :label, :string
    field :organization_id, :id
    field :area_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:label, :function])
    |> validate_required([:label, :function])
  end
end

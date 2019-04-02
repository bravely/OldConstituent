defmodule Constituent.Geomes.Geome do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.Geomes.Geome


  schema "geomes" do
    field :area_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Geome{} = geome, attrs) do
    geome
    |> cast(attrs, [])
    |> validate_required([])
  end
end

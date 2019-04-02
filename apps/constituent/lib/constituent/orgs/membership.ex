defmodule Constituent.Orgs.Membership do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.Orgs.Membership


  schema "memberships" do
    field :label, :string
    field :role, :string
    field :organization_id, :id
    field :area_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Membership{} = membership, attrs) do
    membership
    |> cast(attrs, [:label, :role])
    |> validate_required([:label, :role])
  end
end

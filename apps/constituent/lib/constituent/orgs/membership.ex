defmodule Constituent.Orgs.Membership do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.{
    Orgs.Membership,
    Orgs.Organization,
    People.Person
  }

  schema "memberships" do
    field :label, :string
    field :role, :string

    belongs_to :organization, Organization
    belongs_to :person, Person

    timestamps()
  end

  @doc false
  def changeset(%Membership{} = membership, attrs) do
    membership
    |> cast(attrs, [:label, :role])
    |> validate_required([:label, :role])
  end
end

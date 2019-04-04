defmodule Constituent.People.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Constituent.{
    People.Person,
    Orgs.Membership
  }


  schema "persons" do
    field :biography, :string
    field :date_of_birth, :utc_datetime
    field :name, :string
    field :national_identity, :string
    field :short_biography, :string

    has_many :memberships, Membership
    has_many :organizations, through: [:memberships, :organization]

    timestamps()
  end

  @doc false
  def changeset(%Person{} = person, attrs) do
    person
    |> cast(attrs, [:name, :date_of_birth, :short_biography, :biography, :national_identity])
    |> validate_required([:name, :date_of_birth, :short_biography, :biography, :national_identity])
  end
end

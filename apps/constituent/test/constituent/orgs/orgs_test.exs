defmodule Constituent.OrgsTest do
  use Constituent.DataCase

  alias Constituent.Orgs

  describe "organizations" do
    alias Constituent.Orgs.Organization

    @valid_attrs %{description: "some description", name: "some name", short_description: "some short_description"}
    @update_attrs %{description: "some updated description", name: "some updated name", short_description: "some updated short_description"}
    @invalid_attrs %{description: nil, name: nil, short_description: nil}

    def organization_fixture(attrs \\ %{}) do
      {:ok, organization} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orgs.create_organization()

      organization
    end

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Orgs.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Orgs.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      assert {:ok, %Organization{} = organization} = Orgs.create_organization(@valid_attrs)
      assert organization.description == "some description"
      assert organization.name == "some name"
      assert organization.short_description == "some short_description"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orgs.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      assert {:ok, organization} = Orgs.update_organization(organization, @update_attrs)
      assert %Organization{} = organization
      assert organization.description == "some updated description"
      assert organization.name == "some updated name"
      assert organization.short_description == "some updated short_description"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Orgs.update_organization(organization, @invalid_attrs)
      assert organization == Orgs.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Orgs.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Orgs.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Orgs.change_organization(organization)
    end
  end
end

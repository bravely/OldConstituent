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

  describe "memberships" do
    alias Constituent.Orgs.Membership

    @valid_attrs %{label: "some label", role: "some role"}
    @update_attrs %{label: "some updated label", role: "some updated role"}
    @invalid_attrs %{label: nil, role: nil}

    def membership_fixture(attrs \\ %{}) do
      {:ok, membership} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orgs.create_membership()

      membership
    end

    test "list_memberships/0 returns all memberships" do
      membership = membership_fixture()
      assert Orgs.list_memberships() == [membership]
    end

    test "get_membership!/1 returns the membership with given id" do
      membership = membership_fixture()
      assert Orgs.get_membership!(membership.id) == membership
    end

    test "create_membership/1 with valid data creates a membership" do
      assert {:ok, %Membership{} = membership} = Orgs.create_membership(@valid_attrs)
      assert membership.label == "some label"
      assert membership.role == "some role"
    end

    test "create_membership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orgs.create_membership(@invalid_attrs)
    end

    test "update_membership/2 with valid data updates the membership" do
      membership = membership_fixture()
      assert {:ok, membership} = Orgs.update_membership(membership, @update_attrs)
      assert %Membership{} = membership
      assert membership.label == "some updated label"
      assert membership.role == "some updated role"
    end

    test "update_membership/2 with invalid data returns error changeset" do
      membership = membership_fixture()
      assert {:error, %Ecto.Changeset{}} = Orgs.update_membership(membership, @invalid_attrs)
      assert membership == Orgs.get_membership!(membership.id)
    end

    test "delete_membership/1 deletes the membership" do
      membership = membership_fixture()
      assert {:ok, %Membership{}} = Orgs.delete_membership(membership)
      assert_raise Ecto.NoResultsError, fn -> Orgs.get_membership!(membership.id) end
    end

    test "change_membership/1 returns a membership changeset" do
      membership = membership_fixture()
      assert %Ecto.Changeset{} = Orgs.change_membership(membership)
    end
  end

  describe "posts" do
    alias Constituent.Orgs.Post

    @valid_attrs %{function: "some function", label: "some label"}
    @update_attrs %{function: "some updated function", label: "some updated label"}
    @invalid_attrs %{function: nil, label: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orgs.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Orgs.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Orgs.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Orgs.create_post(@valid_attrs)
      assert post.function == "some function"
      assert post.label == "some label"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orgs.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Orgs.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.function == "some updated function"
      assert post.label == "some updated label"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Orgs.update_post(post, @invalid_attrs)
      assert post == Orgs.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Orgs.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Orgs.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Orgs.change_post(post)
    end
  end
end

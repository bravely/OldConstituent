defmodule Constituent.GeomesTest do
  use Constituent.DataCase

  alias Constituent.Geomes

  describe "geomes" do
    alias Constituent.Geomes.Geome

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def geome_fixture(attrs \\ %{}) do
      {:ok, geome} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Geomes.create_geome()

      geome
    end

    test "list_geomes/0 returns all geomes" do
      geome = geome_fixture()
      assert Geomes.list_geomes() == [geome]
    end

    test "get_geome!/1 returns the geome with given id" do
      geome = geome_fixture()
      assert Geomes.get_geome!(geome.id) == geome
    end

    test "create_geome/1 with valid data creates a geome" do
      assert {:ok, %Geome{} = geome} = Geomes.create_geome(@valid_attrs)
    end

    test "create_geome/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Geomes.create_geome(@invalid_attrs)
    end

    test "update_geome/2 with valid data updates the geome" do
      geome = geome_fixture()
      assert {:ok, geome} = Geomes.update_geome(geome, @update_attrs)
      assert %Geome{} = geome
    end

    test "update_geome/2 with invalid data returns error changeset" do
      geome = geome_fixture()
      assert {:error, %Ecto.Changeset{}} = Geomes.update_geome(geome, @invalid_attrs)
      assert geome == Geomes.get_geome!(geome.id)
    end

    test "delete_geome/1 deletes the geome" do
      geome = geome_fixture()
      assert {:ok, %Geome{}} = Geomes.delete_geome(geome)
      assert_raise Ecto.NoResultsError, fn -> Geomes.get_geome!(geome.id) end
    end

    test "change_geome/1 returns a geome changeset" do
      geome = geome_fixture()
      assert %Ecto.Changeset{} = Geomes.change_geome(geome)
    end
  end
end

defmodule Constituent.PoliticalEntitiesTest do
  use Constituent.DataCase

  alias Constituent.PoliticalEntities

  describe "us_states" do
    alias Constituent.PoliticalEntities.UsState

    @valid_attrs %{division: 42, fips: 42, name: "some name", region: 42, usps: "some usps"}
    @update_attrs %{division: 43, fips: 43, name: "some updated name", region: 43, usps: "some updated usps"}
    @invalid_attrs %{division: nil, fips: nil, name: nil, region: nil, usps: nil}

    def us_state_fixture(attrs \\ %{}) do
      {:ok, us_state} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PoliticalEntities.create_us_state()

      us_state
    end

    test "list_us_states/0 returns all us_states" do
      us_state = us_state_fixture()
      assert PoliticalEntities.list_us_states() == [us_state]
    end

    test "get_us_state!/1 returns the us_state with given id" do
      us_state = us_state_fixture()
      assert PoliticalEntities.get_us_state!(us_state.id) == us_state
    end

    test "create_us_state/1 with valid data creates a us_state" do
      assert {:ok, %UsState{} = us_state} = PoliticalEntities.create_us_state(@valid_attrs)
      assert us_state.division == 42
      assert us_state.fips == 42
      assert us_state.name == "some name"
      assert us_state.region == 42
      assert us_state.usps == "some usps"
    end

    test "create_us_state/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PoliticalEntities.create_us_state(@invalid_attrs)
    end

    test "update_us_state/2 with valid data updates the us_state" do
      us_state = us_state_fixture()
      assert {:ok, us_state} = PoliticalEntities.update_us_state(us_state, @update_attrs)
      assert %UsState{} = us_state
      assert us_state.division == 43
      assert us_state.fips == 43
      assert us_state.name == "some updated name"
      assert us_state.region == 43
      assert us_state.usps == "some updated usps"
    end

    test "update_us_state/2 with invalid data returns error changeset" do
      us_state = us_state_fixture()
      assert {:error, %Ecto.Changeset{}} = PoliticalEntities.update_us_state(us_state, @invalid_attrs)
      assert us_state == PoliticalEntities.get_us_state!(us_state.id)
    end

    test "delete_us_state/1 deletes the us_state" do
      us_state = us_state_fixture()
      assert {:ok, %UsState{}} = PoliticalEntities.delete_us_state(us_state)
      assert_raise Ecto.NoResultsError, fn -> PoliticalEntities.get_us_state!(us_state.id) end
    end

    test "change_us_state/1 returns a us_state changeset" do
      us_state = us_state_fixture()
      assert %Ecto.Changeset{} = PoliticalEntities.change_us_state(us_state)
    end
  end
end

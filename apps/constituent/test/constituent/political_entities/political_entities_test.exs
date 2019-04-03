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
      us_state = us_state_fixture() |> Map.get(:id) |> PoliticalEntities.get_us_state!
      assert PoliticalEntities.list_us_states() == [us_state]
    end

    test "get_us_state!/1 returns the us_state with given id" do
      us_state = us_state_fixture() |> Map.get(:id) |> PoliticalEntities.get_us_state!
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
      us_state = us_state_fixture() |> Map.get(:id) |> PoliticalEntities.get_us_state!
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

  describe "districts" do
    alias Constituent.PoliticalEntities.District

    @valid_attrs %{name: "some name", number_of_seats: 42, open_states_uid: "some open_states_uid", government: "state", chamber: "lower", identifier: "some identifier"}
    @update_attrs %{name: "some updated name", number_of_seats: 43, open_states_uid: "some updated open_states_uid", government: "federal", chamber: "upper", identifier: "some updated identifier"}
    @invalid_attrs %{name: nil, number_of_seats: nil, open_states_uid: nil, government: "nope", chamber: "nope"}

    def district_fixture(attrs \\ %{}) do
      {:ok, district} =
        attrs
        |> Map.merge(%{us_state_fips: us_state_fixture().fips})
        |> Enum.into(@valid_attrs)
        |> PoliticalEntities.create_district()

      district
    end

    test "list_districts/0 returns all districts" do
      district = district_fixture()
      assert PoliticalEntities.list_districts() == [district]
    end

    test "get_district!/1 returns the district with given id" do
      district = district_fixture()
      assert PoliticalEntities.get_district!(district.id) == district
    end

    test "create_district/1 with valid data creates a district" do
      valid_attrs = Map.merge(@valid_attrs, %{us_state_fips: us_state_fixture().fips})
      assert {:ok, %District{} = district} = PoliticalEntities.create_district(valid_attrs)
      assert district.name == "some name"
      assert district.number_of_seats == 42
      assert district.open_states_uid == "some open_states_uid"
    end

    test "create_district/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PoliticalEntities.create_district(@invalid_attrs)
    end

    test "update_district/2 with valid data updates the district" do
      district = district_fixture()
      assert {:ok, district} = PoliticalEntities.update_district(district, @update_attrs)
      assert %District{} = district
      assert district.name == "some updated name"
      assert district.number_of_seats == 43
      assert district.open_states_uid == "some updated open_states_uid"
    end

    test "update_district/2 with invalid data returns error changeset" do
      district = district_fixture()
      assert {:error, %Ecto.Changeset{}} = PoliticalEntities.update_district(district, @invalid_attrs)
      assert district == PoliticalEntities.get_district!(district.id)
    end

    test "delete_district/1 deletes the district" do
      district = district_fixture()
      assert {:ok, %District{}} = PoliticalEntities.delete_district(district)
      assert_raise Ecto.NoResultsError, fn -> PoliticalEntities.get_district!(district.id) end
    end

    test "change_district/1 returns a district changeset" do
      district = district_fixture()
      assert %Ecto.Changeset{} = PoliticalEntities.change_district(district)
    end
  end

  describe "areas" do
    alias Constituent.PoliticalEntities.Area

    @valid_attrs %{
      name: "Idaho",
      identifier: "ID",
      classification: "US State",
      codes: %{
        "USPS" => "ID",
        "FIPS" => 16,
        "region" => 4,
        "division" => 8
      }
    }
    @update_attrs %{
      name: "Washington",
      identifier: "WA",
      classification: "US State",
      codes: %{
        "USPS" => "WA",
        "FIPS" => 53,
        "region" => 4,
        "division" => 9
      }
    }
    @invalid_attrs %{name: nil, identifier: nil, classification: nil, codes: nil}

    def area_fixture(attrs \\ %{}) do
      attrs = Map.merge(@valid_attrs, attrs)

      {:ok, area} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PoliticalEntities.create_area()

      area
    end

    test "list_areas/0 returns all areas" do
      area = area_fixture()
      assert PoliticalEntities.list_areas() == [area]
    end

    test "get_area!/1 returns the area with given id" do
      area = area_fixture()
      assert PoliticalEntities.get_area!(area.id) == area
    end

    test "create_area/1 with valid data creates a area" do
      assert {:ok, %Area{} = area} = PoliticalEntities.create_area(@valid_attrs)
      assert area.name == @valid_attrs.name
      assert area.identifier == @valid_attrs.identifier
      assert area.classification == @valid_attrs.classification
      assert area.codes == @valid_attrs.codes
    end

    test "create_area/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PoliticalEntities.create_area(@invalid_attrs)
    end

    test "update_area/2 with valid data updates the area" do
      area = area_fixture()
      assert {:ok, area} = PoliticalEntities.update_area(area, @update_attrs)
      assert %Area{} = area
    end

    test "update_area/2 with invalid data returns error changeset" do
      area = area_fixture()
      assert {:error, %Ecto.Changeset{}} = PoliticalEntities.update_area(area, @invalid_attrs)
      assert area == PoliticalEntities.get_area!(area.id)
    end

    test "delete_area/1 deletes the area" do
      area = area_fixture()
      assert {:ok, %Area{}} = PoliticalEntities.delete_area(area)
      assert_raise Ecto.NoResultsError, fn -> PoliticalEntities.get_area!(area.id) end
    end

    test "change_area/1 returns a area changeset" do
      area = area_fixture()
      assert %Ecto.Changeset{} = PoliticalEntities.change_area(area)
    end

    test "find_area_by_name/1 returns the area with the given name" do
      area = area_fixture()
      assert PoliticalEntities.find_area_by_name(area.name) == area
    end

    @tag :skip
    test "create_us_state_area/1 with valid data creates a us state area and geome" do
      census_attrs = %{
        attributes: %{
          "NAME" => "Idaho",
          "STUSPS" => "ID",
          "STATEFP" => 16,
          "REGION" => "4 ",
          "DIVISION" => "8 "
        },
        geometry: %Geo.MultiPolygon{srid: 4269, coordinates: [[
          [
            {-73.51808, 41.666723},
            {-73.51807099999999, 41.666782},
            {-73.518064, 41.666843},
            {-73.518011, 41.667572},
            {-73.51783, 41.67012},
            {-73.51777, 41.67097},
            {-73.51808, 41.666723}
          ]
        ]]}
      }

      {:ok, %Area{} = area} = PoliticalEntities.create_us_state_area(census_attrs)
      assert area.name == "Idaho"
      assert area.identifier == "ID"
      assert area.classification == "US State"
      assert area.codes == %{
        "USPS" => "ID",
        "FIPS" => 16,
        "region" => 4,
        "division" => 8
      }
      assert area.geome.boundaries == census_attrs.geometry
    end
  end

  describe "geomes" do
    alias Constituent.PoliticalEntities.Geome

    @valid_attrs %{boundaries: %Geo.MultiPolygon{srid: 4269, coordinates: [[
      [
        {-73.51808, 41.666723},
        {-73.51807099999999, 41.666782},
        {-73.518064, 41.666843},
        {-73.518011, 41.667572},
        {-73.51783, 41.67012},
        {-73.51777, 41.67097},
        {-73.51808, 41.666723}
      ]
    ]]}}
    @update_attrs %{boundaries: %Geo.MultiPolygon{srid: 4269, coordinates: [[
      [
        {-73.51808, 41.666723},
        {-73.51777, 41.67097},
        {-73.51783, 41.67012},
        {-73.518011, 41.667572},
        {-73.518064, 41.666843},
        {-73.51807099999999, 41.666782},
        {-73.51808, 41.666723}
      ]
    ]]}}
    @invalid_attrs %{boundaries: nil}

    def geome_fixture(attrs \\ %{}) do
      area = insert(:area)
      attrs = Map.merge(%{area_id: area.id}, attrs)
      {:ok, geome} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PoliticalEntities.create_geome()

      geome
    end

    test "list_geomes/0 returns all geomes" do
      geome = geome_fixture()
      assert PoliticalEntities.list_geomes() == [geome]
    end

    test "get_geome!/1 returns the geome with given id" do
      geome = geome_fixture()
      assert PoliticalEntities.get_geome!(geome.id) == geome
    end

    test "create_geome/1 with valid data creates a geome" do
      area = insert(:area)
      attrs = Map.merge(%{area_id: area.id}, @valid_attrs)
      assert {:ok, %Geome{} = geome} = PoliticalEntities.create_geome(attrs)
    end

    test "create_geome/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PoliticalEntities.create_geome(@invalid_attrs)
    end

    test "update_geome/2 with valid data updates the geome" do
      geome = geome_fixture()
      assert {:ok, geome} = PoliticalEntities.update_geome(geome, @update_attrs)
      assert %Geome{} = geome
    end

    test "update_geome/2 with invalid data returns error changeset" do
      geome = geome_fixture()
      assert {:error, %Ecto.Changeset{}} = PoliticalEntities.update_geome(geome, @invalid_attrs)
      assert geome == PoliticalEntities.get_geome!(geome.id)
    end

    test "delete_geome/1 deletes the geome" do
      geome = geome_fixture()
      assert {:ok, %Geome{}} = PoliticalEntities.delete_geome(geome)
      assert_raise Ecto.NoResultsError, fn -> PoliticalEntities.get_geome!(geome.id) end
    end

    test "change_geome/1 returns a geome changeset" do
      geome = geome_fixture()
      assert %Ecto.Changeset{} = PoliticalEntities.change_geome(geome)
    end
  end
end

defmodule Researcher.Census.Harvest.UsStatesTest do
  use Constituent.CensusCase
  alias Researcher.Census.Harvest

  describe "harvest_us_states/1" do
    @tag :skip
    test "it creates the right areas" do
      areas =
        census_fixture(:us_states)
        |> Harvest.UsStates.run()
      assert is_list(areas)

      areas_with_ids = Enum.filter(areas, & &1.id)
      assert length(areas) == length(areas_with_ids)

      assert Enum.all?(areas, & &1.classification == "US State")

      assert "Idaho" in Enum.map(areas, & &1.name)
      assert "Puerto Rico" in Enum.map(areas, & &1.name)
      assert "Guam" in Enum.map(areas, & &1.name)
    end

    @tag :skip
    test "it puts in the right codes"
  end
end

defmodule Researcher.OpenStates.Legislators do
  import Ecto.Query

  alias Researcher.OpenStates

  alias Constituent.{
    Repo,
    PoliticalEntities,
    PoliticalEntities.UsState,
    PoliticalEntities.District
  }

  def update_districts do
    PoliticalEntities.list_us_states()
    |> Flow.from_enumerable()
    |> Flow.flat_map(&update_districts/1)
    |> Flow.map(&Repo.update/1)
    |> Enum.to_list()
  end

  def update_districts(%UsState{usps: usps} = us_state) do
    os_districts = open_states_districts_for(usps)

    us_state
    |> relevant_districts_for_state
    |> Enum.map(&find_os_district(&1, os_districts))
    |> Enum.map(&district_changeset/1)
  end

  def relevant_districts_for_state(us_state) do
    us_state
    |> Ecto.assoc(:districts)
    |> where([d], d.government == "state")
    |> where([d], not like(d.identifier, "ZZ%"))
    |> Repo.all()
  end

  def match_os_district(district, os_districts) do
    {district, find_os_district(district, os_districts)}
  end

  def find_os_district(district, [%{"abbr" => "nh"} | _tail] = os_districts) do
    Enum.find(os_districts, fn %{"name" => os_name, "chamber" => os_chamber} ->
      os_name = String.downcase(os_name)

      Enum.all?(String.split(os_name), fn word ->
        if String.match?(word, ~r/^\d+$/) do
          String.match?(district.name, ~r/ #{word}$/)
        else
          String.contains?(String.downcase(district.name), word)
        end and os_chamber == district.chamber
      end)
    end)
  end

  def find_os_district(district, [%{"abbr" => "vt"} | _tail] = os_districts) do
    Enum.find(os_districts, fn os_district ->
      compare_vt_names(district, os_district)
    end)
  end

  def find_os_district(district, [%{"abbr" => "pr"} | _tail] = os_districts) do
    Enum.find(os_districts, fn %{"name" => os_name} ->
      district_name = district.name |> String.split() |> List.last()

      district_name == os_name
    end)
  end

  # USE THE FUCKING DIVISION ID
  def find_os_district(
        district,
        [%{"abbr" => "ma"} | _tail] = os_districts
      ) do
    division_name = ma_district_name(district)

    Enum.find(os_districts, fn os_district ->
      String.ends_with?(os_district["division_id"], division_name) and
        os_district["chamber"] == district.chamber
    end)
  end

  def find_os_district(
        %{name: district_name} = district,
        [%{"abbr" => "dc"} | _tail] = os_districts
      ) do
    Enum.find(os_districts, fn os_district ->
      district_name == os_district["name"] and os_district["chamber"] == district.chamber
    end)
  end

  def find_os_district(district, os_districts) do
    os_districts
    |> Enum.find(fn os_district ->
      padded_identifier_matches(os_district, district) and
        os_district["chamber"] == district.chamber
    end)
  end

  defp open_states_districts_for(state_abbr) do
    {:ok, resp} = OpenStates.get_districts_for_state(state_abbr)
    resp.body
  end

  def ma_numbered_name(district_name, starting_word) do
    district_name
    |> String.split()
    |> Enum.drop(1)
    |> List.insert_at(0, starting_word)
    |> Enum.join(" ")
    |> String.downcase()
  end

  def starting_number(name) do
    name
    |> String.split()
    |> List.first()
    |> String.split("")
    |> Enum.reverse()
    |> Enum.drop(3)
    |> Enum.reverse()
    |> Enum.join()
    |> String.to_integer()
  end

  def compare_vt_names(%{name: name}, %{"name" => os_name}) do
    district_name =
      name
      |> comparable_words
      |> Enum.reverse()
      |> Enum.drop(2)
      |> Enum.reverse()

    openstates_name = comparable_words(os_name) ++ ["State"]

    district_name == openstates_name
  end

  def comparable_words(name) do
    name
    |> String.split()
    |> Enum.flat_map(&String.split(&1, "-"))
  end

  def ma_district_name(%{name: name, chamber: chamber}) do
    name
    |> String.replace("&", "and")
    |> String.replace(",", "")
    |> String.downcase()
    |> String.split()
    |> replace_written_ordinal
    |> Enum.reverse()
    |> Enum.drop(1)
    |> Enum.reverse()
    |> Enum.join("_")
    |> prepend_division_string(chamber)
  end

  defp replace_written_ordinal(["first" | other]), do: ["1st" | other]
  defp replace_written_ordinal(["second" | other]), do: ["2nd" | other]
  defp replace_written_ordinal(["third" | other]), do: ["3rd" | other]
  defp replace_written_ordinal(["fourth" | other]), do: ["4th" | other]
  defp replace_written_ordinal(["fifth" | other]), do: ["5th" | other]
  defp replace_written_ordinal(list), do: list

  defp prepend_division_string(name, "lower"), do: "sldl:" <> name
  defp prepend_division_string(name, "upper"), do: "sldu:" <> name

  defp district_changeset({district, nil}) do
    require IEx
    IEx.pry()
  end

  defp district_changeset({district, matching_os_district}) do
    District.changeset(district, district_mapping(matching_os_district))
  end

  defp padded_identifier_matches(%{"name" => os_district_name}, %District{identifier: identifier}) do
    String.pad_leading(os_district_name, String.length(identifier), "0") == identifier
  end

  defp district_mapping(%{"id" => open_states_uid, "num_seats" => number_of_seats}) do
    %{
      open_states_uid: open_states_uid,
      number_of_seats: number_of_seats,
      us_states_refreshed_at: DateTime.utc_now()
    }
  end
end

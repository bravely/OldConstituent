defmodule Constituent.CensusCase do
  use ExUnit.CaseTemplate
  using do
    quote do
      use Constituent.DataCase
      import Constituent.CensusCase
    end
  end

  def census_fixture(:us_states) do
    fixture_path = downloads_path() <> "tl_2018_us_state.zip"
    unless File.exists?(fixture_path) do
      raise "Expected #{fixture_path} to exist. Run mix `census.download.us_states`"
    end
    fixture_path
  end

  defp downloads_path do
    if String.ends_with?(File.cwd!, "constituent/apps/constituent") do
      "../../downloads/"
    else
      "downloads/"
    end
  end
end

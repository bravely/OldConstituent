defmodule Mix.Tasks.Researcher.Geo.Cd do
  @moduledoc """
  Harvests federal Congressional District TIGER map data.
  """
  use Mix.Task

  @shortdoc "Downloads federal Congressional District files."
  def run([]) do
    "ftp2.census.gov"
    |> EfTP.connect(user: "anonymous", password: "")
    |> EfTP.cd("geo/tiger/TIGER2017/CD/")
    |> EfTP.download_directory("downloads", log: true)
  end
end

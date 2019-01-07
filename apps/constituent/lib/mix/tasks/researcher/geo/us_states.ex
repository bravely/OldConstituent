defmodule Mix.Tasks.Researcher.Geo.State do
  @moduledoc """
  Harvests US State boundaries TIGER map data.
  """
  use Mix.Task

  @shortdoc "Downloads the Us State shapefile."
  def run([]) do
    "ftp2.census.gov"
    |> EfTP.connect(user: "anonymous", password: "")
    |> EfTP.cd("geo/tiger/TIGER2017/STATE/")
    |> EfTP.download_directory("downloads", log: true)
  end
end

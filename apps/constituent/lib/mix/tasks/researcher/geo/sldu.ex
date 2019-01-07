defmodule Mix.Tasks.Researcher.Geo.Sldu do
  @moduledoc """
  Harvests State Legislature Upper District TIGER map data.
  """
  use Mix.Task

  @shortdoc "Downloads State Lower House district files."
  def run([]) do
    "ftp2.census.gov"
    |> EfTP.connect(user: "anonymous", password: "")
    |> EfTP.cd("geo/tiger/TIGER2017/SLDU/")
    |> EfTP.download_directory("downloads", log: true)
  end
end

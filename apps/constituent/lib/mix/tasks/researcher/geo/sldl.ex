defmodule Mix.Tasks.Researcher.Geo.Sldl do
  @moduledoc """
  Harvests State Legislature Lower District TIGER map data.
  """
  use Mix.Task

  @shortdoc "Downloads State Lower House district files."
  def run([]) do
    "ftp2.census.gov"
    |> EfTP.connect(user: "anonymous", password: "")
    |> EfTP.cd("geo/tiger/TIGER2017/SLDL/")
    |> EfTP.download_directory("downloads", log: true)
  end
end

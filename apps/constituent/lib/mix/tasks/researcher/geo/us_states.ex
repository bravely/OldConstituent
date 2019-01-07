defmodule Mix.Tasks.Researcher.Geo.State do
  @moduledoc """
  Harvests US State boundaries TIGER map data.
  """
  use Mix.Task

  @shortdoc "Downloads the Us State shapefile."
  def run([]) do
    Researcher.Census.download_directory("geo/tiger/TIGER2017/STATE/")
  end
end

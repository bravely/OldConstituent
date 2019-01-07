defmodule Mix.Tasks.Researcher.Geo.Cd do
  @moduledoc """
  Harvests federal Congressional District TIGER map data.
  """
  use Mix.Task

  @shortdoc "Downloads federal Congressional District files."
  def run([]) do
    Researcher.Census.download_directory("geo/tiger/TIGER2017/CD/")
  end
end

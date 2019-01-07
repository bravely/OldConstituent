defmodule Mix.Tasks.Researcher.Geo.Sldu do
  @moduledoc """
  Harvests State Legislature Upper District TIGER map data.
  """
  use Mix.Task

  @shortdoc "Downloads State Lower House district files."
  def run([]) do
    Researcher.Census.download_directory("geo/tiger/TIGER2017/SLDU/")
  end
end

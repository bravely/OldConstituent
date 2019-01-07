defmodule Mix.Tasks.Researcher.Geo.Sldl do
  @moduledoc """
  Harvests State Legislature Lower District TIGER map data.
  """
  use Mix.Task

  @shortdoc "Downloads State Lower House district files."
  def run([]) do
    Researcher.Census.download_directory("geo/tiger/TIGER2017/SLDL/")
  end
end

defmodule Researcher.Census.Download.UsStates do
  require Logger
  alias Researcher.Census

  def ftp_download do
    [path] = Census.download_directory("geo/tiger/TIGER2018/STATE/")

    Logger.info("Downloading UsStates to #{path}")
    path
  end
end

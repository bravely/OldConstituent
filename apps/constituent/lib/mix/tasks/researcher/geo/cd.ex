defmodule Mix.Tasks.Researcher.Geo.Cd do
  @moduledoc """
  Harvests federal Congressional District TIGER map data.
  """
  use Mix.Task

  @shortdoc "Downloads and harvests federal Congressional District files."
  def run([]) do
    :inets.start()
    {:ok, conn} = EfTP.connect("ftp2.census.gov", user: "anonymous", password: "")
    :ok = EfTP.cd(conn, "geo/tiger/TIGER2017/CD/")

    {:ok, file_list} = EfTP.nlist(conn)

    file_list
    |> Enum.reject(fn(filename) -> filename == "" end)
    |> Enum.map(fn(filename) -> # FTP doesn't like parallel downloads
      path = "downloads/#{filename}"
      IO.puts path
      EfTP.download(conn, filename, path)
      path
    end)
  end
end

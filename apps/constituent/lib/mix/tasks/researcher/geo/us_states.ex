defmodule Mix.Tasks.Researcher.Geo.State do
  @moduledoc """
  Harvests US State boundaries TIGER map data.
  """
  use Mix.Task

  @shortdoc "Downloads the Us State shapefile."
  def run([]) do
    :inets.start()
    {:ok, conn} = EfTP.connect("ftp2.census.gov", user: "anonymous", password: "")
    :ok = EfTP.cd(conn, "geo/tiger/TIGER2017/STATE/")

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

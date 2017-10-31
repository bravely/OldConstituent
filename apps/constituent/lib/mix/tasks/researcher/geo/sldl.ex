defmodule Mix.Tasks.Researcher.Geo.Sldl do
  @moduledoc """
  Harvests State Legislature Lower District TIGER map data.
  """
  use Mix.Task

  @shortdoc "Downloads and harvests State Lower House district files."
  def run([]) do
    :inets.start()
    {:ok, conn} = EfTP.connect("ftp2.census.gov", user: "anonymous", password: "")
    :ok = EfTP.cd(conn, "geo/tiger/TIGER2017/SLDL/")

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

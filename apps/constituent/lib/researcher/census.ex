defmodule Researcher.Census do
  alias Constituent.{Repo, PoliticalEntities}
  alias Constituent.PoliticalEntities.UsState

  def download_directory(dir) do
    :ok = EfTP.assure_inets()
    {:ok, conn} = EfTP.connect("ftp2.census.gov", user: "anonymous", password: "")
    :ok = EfTP.cd(conn, dir)

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

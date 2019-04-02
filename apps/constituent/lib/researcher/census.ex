defmodule Researcher.Census do
  def download_directory(dir) do
    "ftp2.census.gov"
    |> EfTP.connect!(user: "anonymous", password: "")
    |> EfTP.cd!(dir)
    |> EfTP.download_directory("downloads", log: true)
  end
end

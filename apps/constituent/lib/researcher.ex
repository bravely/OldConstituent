defmodule Researcher do
  def filter_downloads(regex) do
    {:ok, paths} = File.ls("downloads/")

    Enum.filter(paths, fn(path) ->
      String.match?(path, regex)
    end)
  end
end

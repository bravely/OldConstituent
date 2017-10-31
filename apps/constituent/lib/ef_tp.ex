defmodule EfTP do
  @moduledoc """
  EfTP is FTP for Elixir.
  """

  :inets.start()
  def assure_inets do
    case :inets.start() do
      {:error, {:already_started, :inets}} -> :ok
      :ok -> :ok
      other -> other
    end
  end

  def connect(host, opts \\ []) do
    {:ok, pid} = :inets.start(:ftpc, host: to_charlist(host))
    if opts[:user] do
      :ftp.user(pid, to_charlist(opts[:user]), to_charlist(opts[:password]))
    end
    {:ok, pid}
  end

  def nlist(pid) do
    with {:ok, charlist} <- :ftp.nlist(pid) do
      file_list =
        charlist
        |> to_string
        |> String.split("\r\n")

      {:ok, file_list}
    else
      other -> other
    end
  end

  def cd(pid, path), do: :ftp.cd(pid, to_charlist(path))

  def pwd(pid) do
    with {:ok, path} <- :ftp.pwd(pid) do
      {:ok, to_string(path)}
    else
      other -> other
    end
  end

  def download(pid, filename), do: download(pid, filename, filename)
  def download(pid, filename, local_name) do
    assure_local_path_exists(local_name)
    :ftp.recv(pid, to_charlist(filename), to_charlist(local_name))
  end

  defp assure_local_path_exists(path) do
    path
    |> Path.dirname
    |> File.mkdir_p
  end
end

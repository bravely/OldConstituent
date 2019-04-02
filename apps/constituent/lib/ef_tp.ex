defmodule EfTP do
  @moduledoc """
  EfTP is FTP for Elixir.
  """
  require Logger

  def connect(host, opts \\ []) do
    try do
      {:ok, pid} = :inets.start(:ftpc, host: to_charlist(host))

      if opts[:user] do
        :ftp.user(pid, to_charlist(opts[:user]), to_charlist(opts[:password]))
      end

      {:ok, pid}
    rescue
      e -> {:error, e}
    end
  end

  def connect!(host, opts \\ []) do
    case connect(host, opts) do
      {:ok, pid} -> pid
      {:error, e} -> raise e
    end
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

  def nlist!(pid) do
    case nlist(pid) do
      {:ok, file_list} -> file_list
      other -> raise other
    end
  end

  def cd(conn, path) do
    case :ftp.cd(conn, to_charlist(path)) do
      :ok -> conn
      {:error, _reason} = other -> other
    end
  end

  def cd!(conn, path) do
    case cd(conn, path) do
      ^conn -> conn
      {:error, error} -> raise error
    end
  end

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
    |> Path.dirname()
    |> File.mkdir_p()
  end

  def download_directory(conn, path, opts \\ []) do
    conn
    |> EfTP.nlist!()
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn filename ->
      file_path = "#{path}/#{filename}"

      if opts[:log] == true do
        Logger.info("Downloading to #{file_path}...")
      end

      EfTP.download(conn, filename, file_path)
      file_path
    end)
  end
end

defmodule Constituent.Geomes do
  @moduledoc """
  The Geomes context.
  """

  import Ecto.Query, warn: false
  alias Constituent.Repo

  alias Constituent.Geomes.Geome

  @doc """
  Returns the list of geomes.

  ## Examples

      iex> list_geomes()
      [%Geome{}, ...]

  """
  def list_geomes do
    Repo.all(Geome)
  end

  @doc """
  Gets a single geome.

  Raises `Ecto.NoResultsError` if the Geome does not exist.

  ## Examples

      iex> get_geome!(123)
      %Geome{}

      iex> get_geome!(456)
      ** (Ecto.NoResultsError)

  """
  def get_geome!(id), do: Repo.get!(Geome, id)

  @doc """
  Creates a geome.

  ## Examples

      iex> create_geome(%{field: value})
      {:ok, %Geome{}}

      iex> create_geome(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_geome(attrs \\ %{}) do
    %Geome{}
    |> Geome.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a geome.

  ## Examples

      iex> update_geome(geome, %{field: new_value})
      {:ok, %Geome{}}

      iex> update_geome(geome, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_geome(%Geome{} = geome, attrs) do
    geome
    |> Geome.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Geome.

  ## Examples

      iex> delete_geome(geome)
      {:ok, %Geome{}}

      iex> delete_geome(geome)
      {:error, %Ecto.Changeset{}}

  """
  def delete_geome(%Geome{} = geome) do
    Repo.delete(geome)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking geome changes.

  ## Examples

      iex> change_geome(geome)
      %Ecto.Changeset{source: %Geome{}}

  """
  def change_geome(%Geome{} = geome) do
    Geome.changeset(geome, %{})
  end
end

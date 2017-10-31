defmodule Constituent.PoliticalEntities do
  @moduledoc """
  The PoliticalEntities context.
  """

  import Ecto.Query, warn: false
  import Geo.PostGIS
  alias Constituent.Repo

  alias Constituent.PoliticalEntities.UsState

  @doc """
  Returns the list of us_states.

  ## Examples

      iex> list_us_states()
      [%UsState{}, ...]

  """
  def list_us_states do
    Repo.all(UsState)
  end

  @doc """
  Gets a single us_state.

  Raises `Ecto.NoResultsError` if the UsState does not exist.

  ## Examples

      iex> get_us_state!(123)
      %UsState{}

      iex> get_us_state!(456)
      ** (Ecto.NoResultsError)

  """
  def get_us_state!(id), do: Repo.get!(UsState, id)

  def us_states_containing(geom) do
    Repo.all(from u in UsState, where: st_contains(u.boundaries, ^geom))
  end

  @doc """
  Creates a us_state.

  ## Examples

      iex> create_us_state(%{field: value})
      {:ok, %UsState{}}

      iex> create_us_state(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_us_state(attrs \\ %{}) do
    %UsState{}
    |> UsState.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a us_state.

  ## Examples

      iex> update_us_state(us_state, %{field: new_value})
      {:ok, %UsState{}}

      iex> update_us_state(us_state, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_us_state(%UsState{} = us_state, attrs) do
    us_state
    |> UsState.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UsState.

  ## Examples

      iex> delete_us_state(us_state)
      {:ok, %UsState{}}

      iex> delete_us_state(us_state)
      {:error, %Ecto.Changeset{}}

  """
  def delete_us_state(%UsState{} = us_state) do
    Repo.delete(us_state)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking us_state changes.

  ## Examples

      iex> change_us_state(us_state)
      %Ecto.Changeset{source: %UsState{}}

  """
  def change_us_state(%UsState{} = us_state) do
    UsState.changeset(us_state, %{})
  end
end

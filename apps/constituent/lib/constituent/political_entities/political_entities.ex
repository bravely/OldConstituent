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

  def get_us_state_by(attrs) when is_list(attrs) do
    Repo.get_by(UsState, attrs)
  end

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

  alias Constituent.PoliticalEntities.District

  @doc """
  Returns the list of districts.

  ## Examples

      iex> list_districts()
      [%District{}, ...]

  """
  def list_districts do
    Repo.all(District)
  end

  @doc """
  Gets a single district.

  Raises `Ecto.NoResultsError` if the District does not exist.

  ## Examples

      iex> get_district!(123)
      %District{}

      iex> get_district!(456)
      ** (Ecto.NoResultsError)

  """
  def get_district!(id), do: Repo.get!(District, id)

  @doc """
  Creates a district.

  ## Examples

      iex> create_district(%{field: value})
      {:ok, %District{}}

      iex> create_district(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_district(attrs \\ %{}) do
    %District{}
    |> District.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a district.

  ## Examples

      iex> update_district(district, %{field: new_value})
      {:ok, %District{}}

      iex> update_district(district, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_district(%District{} = district, attrs) do
    district
    |> District.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a District.

  ## Examples

      iex> delete_district(district)
      {:ok, %District{}}

      iex> delete_district(district)
      {:error, %Ecto.Changeset{}}

  """
  def delete_district(%District{} = district) do
    Repo.delete(district)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking district changes.

  ## Examples

      iex> change_district(district)
      %Ecto.Changeset{source: %District{}}

  """
  def change_district(%District{} = district) do
    District.changeset(district, %{})
  end
end

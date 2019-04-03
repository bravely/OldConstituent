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
    attrs
    |> us_state_where
    |> Repo.one
  end

  def get_us_state_with_area_by(attrs) when is_list(attrs) do
    attrs
    |> us_state_where
    |> preload(:area)
    |> Repo.one
  end

  defp us_state_where(attrs) do
    where(UsState, ^attrs)
  end

  def us_states_containing(geom) do
    # Repo.all(from u in UsState, where: st_contains(u.boundaries, ^geom))
    UsState
    |> join(:inner, g in Area)
    |> where([u, g], st_contains(g.boundaries, ^geom))
    |> Repo.all
  end

  @doc """
  Creates a us_state.

  ## Examples

      iex> create_us_state(%{field: value})
      {:ok, %UsState{}}

      iex> create_us_state(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_us_state(attrs) do
    %UsState{}
    |> UsState.area_changeset(attrs)
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
  def update_us_state(%UsState{} = us_state, %{area: _area_changes} = attrs) do
    us_state
    |> UsState.area_changeset(attrs)
    |> Repo.update()
  end
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

  def get_district_by(attrs) do
    Repo.get_by(District, attrs)
  end

  def get_district_with_area_by(attrs) do
    District
    |> preload(:area)
    |> Repo.get_by(attrs)
  end

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

  alias Constituent.PoliticalEntities.Area

  @doc """
  Returns the list of areas.

  ## Examples

      iex> list_areas()
      [%Area{}, ...]

  """
  def list_areas do
    Repo.all(Area)
  end

  @doc """
  Gets a single area.

  Raises `Ecto.NoResultsError` if the Area does not exist.

  ## Examples

      iex> get_area!(123)
      %Area{}

      iex> get_area!(456)
      ** (Ecto.NoResultsError)

  """
  def get_area!(id), do: Repo.get!(Area, id)

  @doc """
  Creates a area.

  ## Examples

      iex> create_area(%{field: value})
      {:ok, %Area{}}

      iex> create_area(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_area(attrs \\ %{}) do
    %Area{}
    |> Area.changeset(attrs)
    |> Repo.insert()
  end

  def create_us_state_area(census_attrs) do
    census_attrs
    |> Area.intake_census_state()
    |> create_area()
  end

  @doc """
  Updates a area.

  ## Examples

      iex> update_area(area, %{field: new_value})
      {:ok, %Area{}}

      iex> update_area(area, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_area(%Area{} = area, attrs) do
    area
    |> Area.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Area.

  ## Examples

      iex> delete_area(area)
      {:ok, %Area{}}

      iex> delete_area(area)
      {:error, %Ecto.Changeset{}}

  """
  def delete_area(%Area{} = area) do
    Repo.delete(area)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking area changes.

  ## Examples

      iex> change_area(area)
      %Ecto.Changeset{source: %Area{}}

  """
  def change_area(%Area{} = area) do
    Area.changeset(area, %{})
  end

  def find_area_by_name(name) when is_binary(name) do
    Repo.get_by(Area, name: name)
  end

  alias Constituent.PoliticalEntities.Geome

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

defmodule Yearbook.University do
  @moduledoc """
  The University context.
  """

  import Ecto.Query, warn: false
  alias Yearbook.Repo

  alias Yearbook.University.AcademicYear

  @doc """
  Returns the list of academic_years.

  ## Examples

      iex> list_academic_years()
      [%AcademicYear{}, ...]

  """
  def list_academic_years do
    Repo.all(AcademicYear)
  end

  @doc """
  Gets a single academic_year.

  Raises `Ecto.NoResultsError` if the Academic year does not exist.

  ## Examples

      iex> get_academic_year!(123)
      %AcademicYear{}

      iex> get_academic_year!(456)
      ** (Ecto.NoResultsError)

  """
  def get_academic_year!(id), do: Repo.get!(AcademicYear, id)

  @doc """
  Creates a academic_year.

  ## Examples

      iex> create_academic_year(%{field: value})
      {:ok, %AcademicYear{}}

      iex> create_academic_year(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_academic_year(attrs \\ %{}) do
    %AcademicYear{}
    |> AcademicYear.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a academic_year.

  ## Examples

      iex> update_academic_year(academic_year, %{field: new_value})
      {:ok, %AcademicYear{}}

      iex> update_academic_year(academic_year, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_academic_year(%AcademicYear{} = academic_year, attrs) do
    academic_year
    |> AcademicYear.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a academic_year.

  ## Examples

      iex> delete_academic_year(academic_year)
      {:ok, %AcademicYear{}}

      iex> delete_academic_year(academic_year)
      {:error, %Ecto.Changeset{}}

  """
  def delete_academic_year(%AcademicYear{} = academic_year) do
    Repo.delete(academic_year)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking academic_year changes.

  ## Examples

      iex> change_academic_year(academic_year)
      %Ecto.Changeset{data: %AcademicYear{}}

  """
  def change_academic_year(%AcademicYear{} = academic_year, attrs \\ %{}) do
    AcademicYear.changeset(academic_year, attrs)
  end

  alias Yearbook.University.Degree

  @doc """
  Returns the list of degrees.

  ## Examples

      iex> list_degrees()
      [%Degree{}, ...]

  """
  def list_degrees do
    Repo.all(Degree)
  end

  @doc """
  Gets a single degree.

  Raises `Ecto.NoResultsError` if the Degree does not exist.

  ## Examples

      iex> get_degree!(123)
      %Degree{}

      iex> get_degree!(456)
      ** (Ecto.NoResultsError)

  """
  def get_degree!(id), do: Repo.get!(Degree, id)

  @doc """
  Creates a degree.

  ## Examples

      iex> create_degree(%{field: value})
      {:ok, %Degree{}}

      iex> create_degree(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_degree(attrs \\ %{}) do
    %Degree{}
    |> Degree.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a degree.

  ## Examples

      iex> update_degree(degree, %{field: new_value})
      {:ok, %Degree{}}

      iex> update_degree(degree, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_degree(%Degree{} = degree, attrs) do
    degree
    |> Degree.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a degree.

  ## Examples

      iex> delete_degree(degree)
      {:ok, %Degree{}}

      iex> delete_degree(degree)
      {:error, %Ecto.Changeset{}}

  """
  def delete_degree(%Degree{} = degree) do
    Repo.delete(degree)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking degree changes.

  ## Examples

      iex> change_degree(degree)
      %Ecto.Changeset{data: %Degree{}}

  """
  def change_degree(%Degree{} = degree, attrs \\ %{}) do
    Degree.changeset(degree, attrs)
  end

  alias Yearbook.University.Class

  @doc """
  Returns the list of classes.

  ## Examples

      iex> list_classes()
      [%Class{}, ...]

  """
  def list_classes(preloads \\ []) do
    Class
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  @doc """
  Gets a single class.

  Raises `Ecto.NoResultsError` if the Class does not exist.

  ## Examples

      iex> get_class!(123)
      %Class{}

      iex> get_class!(456)
      ** (Ecto.NoResultsError)

  """
  def get_class!(id), do: Repo.get!(Class, id)

  @doc """
  Creates a class.

  ## Examples

      iex> create_class(%{field: value})
      {:ok, %Class{}}

      iex> create_class(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_class(attrs \\ %{}) do
    %Class{}
    |> Class.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a class.

  ## Examples

      iex> update_class(class, %{field: new_value})
      {:ok, %Class{}}

      iex> update_class(class, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_class(%Class{} = class, attrs) do
    class
    |> Class.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a class.

  ## Examples

      iex> delete_class(class)
      {:ok, %Class{}}

      iex> delete_class(class)
      {:error, %Ecto.Changeset{}}

  """
  def delete_class(%Class{} = class) do
    Repo.delete(class)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking class changes.

  ## Examples

      iex> change_class(class)
      %Ecto.Changeset{data: %Class{}}

  """
  def change_class(%Class{} = class, attrs \\ %{}) do
    Class.changeset(class, attrs)
  end
end

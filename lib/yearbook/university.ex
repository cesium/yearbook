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
end

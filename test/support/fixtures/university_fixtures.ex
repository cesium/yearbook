defmodule Yearbook.UniversityFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Yearbook.University` context.
  """

  @doc """
  Generate a academic_year.
  """
  def academic_year_fixture(attrs \\ %{}) do
    {:ok, academic_year} =
      attrs
      |> Enum.into(%{
        finish: 2020,
        start: 2021
      })
      |> Yearbook.University.create_academic_year()

    academic_year
  end

  @doc """
  Generate a degree.
  """
  def degree_fixture(attrs \\ %{}) do
    {:ok, degree} =
      attrs
      |> Enum.into(%{
        cycle: 2,
        name: "Software Engineering"
      })
      |> Yearbook.University.create_degree()

    degree
  end

  @doc """
  Generate a class.
  """
  def class_fixture(attrs \\ %{}) do
    {:ok, class} =
      attrs
      |> Enum.into(%{
        grade: 3,
        degree_id: degree_fixture().id,
        academic_year_id: academic_year_fixture().id
      })
      |> Yearbook.University.create_class()

    class
  end
end

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
end

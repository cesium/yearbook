defmodule Yearbook.UniversityTest do
  use Yearbook.DataCase

  alias Yearbook.University

  describe "academic_years" do
    alias Yearbook.University.AcademicYear

    import Yearbook.UniversityFixtures

    @invalid_attrs %{finish: nil, start: nil}

    test "list_academic_years/0 returns all academic_years" do
      academic_year = academic_year_fixture()
      assert University.list_academic_years() == [academic_year]
    end

    test "get_academic_year!/1 returns the academic_year with given id" do
      academic_year = academic_year_fixture()
      assert University.get_academic_year!(academic_year.id) == academic_year
    end

    test "create_academic_year/1 with valid data creates a academic_year" do
      valid_attrs = %{finish: 42, start: 42}

      assert {:ok, %AcademicYear{} = academic_year} = University.create_academic_year(valid_attrs)
      assert academic_year.finish == 42
      assert academic_year.start == 42
    end

    test "create_academic_year/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = University.create_academic_year(@invalid_attrs)
    end

    test "update_academic_year/2 with valid data updates the academic_year" do
      academic_year = academic_year_fixture()
      update_attrs = %{finish: 43, start: 43}

      assert {:ok, %AcademicYear{} = academic_year} = University.update_academic_year(academic_year, update_attrs)
      assert academic_year.finish == 43
      assert academic_year.start == 43
    end

    test "update_academic_year/2 with invalid data returns error changeset" do
      academic_year = academic_year_fixture()
      assert {:error, %Ecto.Changeset{}} = University.update_academic_year(academic_year, @invalid_attrs)
      assert academic_year == University.get_academic_year!(academic_year.id)
    end

    test "delete_academic_year/1 deletes the academic_year" do
      academic_year = academic_year_fixture()
      assert {:ok, %AcademicYear{}} = University.delete_academic_year(academic_year)
      assert_raise Ecto.NoResultsError, fn -> University.get_academic_year!(academic_year.id) end
    end

    test "change_academic_year/1 returns a academic_year changeset" do
      academic_year = academic_year_fixture()
      assert %Ecto.Changeset{} = University.change_academic_year(academic_year)
    end
  end
end

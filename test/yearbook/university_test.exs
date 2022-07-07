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
      valid_attrs = %{start: 2010, finish: 2011}

      assert {:ok, %AcademicYear{} = academic_year} = University.create_academic_year(valid_attrs)
      assert academic_year.start == 2010
      assert academic_year.finish == 2011
    end

    test "create_academic_year/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = University.create_academic_year(@invalid_attrs)
    end

    test "update_academic_year/2 with valid data updates the academic_year" do
      academic_year = academic_year_fixture()
      update_attrs = %{start: 2014, finish: 2015}

      assert {:ok, %AcademicYear{} = academic_year} =
               University.update_academic_year(academic_year, update_attrs)

      assert academic_year.start == 2014
      assert academic_year.finish == 2015
    end

    test "update_academic_year/2 with invalid data returns error changeset" do
      academic_year = academic_year_fixture()

      assert {:error, %Ecto.Changeset{}} =
               University.update_academic_year(academic_year, @invalid_attrs)

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

  describe "degrees" do
    alias Yearbook.University.Degree

    import Yearbook.UniversityFixtures

    @invalid_attrs %{cycle: nil, name: nil}

    test "list_degrees/0 returns all degrees" do
      degree = degree_fixture()
      assert University.list_degrees() == [degree]
    end

    test "get_degree!/1 returns the degree with given id" do
      degree = degree_fixture()
      assert University.get_degree!(degree.id) == degree
    end

    test "create_degree/1 with valid data creates a degree" do
      valid_attrs = %{cycle: 2, name: "some name"}

      assert {:ok, %Degree{} = degree} = University.create_degree(valid_attrs)
      assert degree.cycle == 2
      assert degree.name == "some name"
    end

    test "create_degree/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = University.create_degree(@invalid_attrs)
    end

    test "update_degree/2 with valid data updates the degree" do
      degree = degree_fixture()
      update_attrs = %{cycle: 3, name: "some updated name"}

      assert {:ok, %Degree{} = degree} = University.update_degree(degree, update_attrs)
      assert degree.cycle == 3
      assert degree.name == "some updated name"
    end

    test "update_degree/2 with invalid data returns error changeset" do
      degree = degree_fixture()
      assert {:error, %Ecto.Changeset{}} = University.update_degree(degree, @invalid_attrs)
      assert degree == University.get_degree!(degree.id)
    end

    test "delete_degree/1 deletes the degree" do
      degree = degree_fixture()
      assert {:ok, %Degree{}} = University.delete_degree(degree)
      assert_raise Ecto.NoResultsError, fn -> University.get_degree!(degree.id) end
    end

    test "change_degree/1 returns a degree changeset" do
      degree = degree_fixture()
      assert %Ecto.Changeset{} = University.change_degree(degree)
    end
  end

  describe "classes" do
    alias Yearbook.University.Class

    import Yearbook.UniversityFixtures

    @invalid_attrs %{grade: nil}

    test "list_classes/0 returns all classes" do
      class = class_fixture()
      assert University.list_classes() == [class]
    end

    test "get_class!/1 returns the class with given id" do
      class = class_fixture()
      assert University.get_class!(class.id) == class
    end

    test "create_class/1 with valid data creates a class" do
      valid_attrs = %{
        grade: 2,
        degree_id: degree_fixture().id,
        academic_year_id: academic_year_fixture().id
      }

      assert {:ok, %Class{} = class} = University.create_class(valid_attrs)
      assert class.grade == 2
    end

    test "create_class/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = University.create_class(@invalid_attrs)
    end

    test "update_class/2 with valid data updates the class" do
      class = class_fixture()
      update_attrs = %{grade: 3}

      assert {:ok, %Class{} = class} = University.update_class(class, update_attrs)
      assert class.grade == 3
    end

    test "update_class/2 with invalid data returns error changeset" do
      class = class_fixture()
      assert {:error, %Ecto.Changeset{}} = University.update_class(class, @invalid_attrs)
      assert class == University.get_class!(class.id)
    end

    test "delete_class/1 deletes the class" do
      class = class_fixture()
      assert {:ok, %Class{}} = University.delete_class(class)
      assert_raise Ecto.NoResultsError, fn -> University.get_class!(class.id) end
    end

    test "change_class/1 returns a class changeset" do
      class = class_fixture()
      assert %Ecto.Changeset{} = University.change_class(class)
    end
  end
end

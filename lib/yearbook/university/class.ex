defmodule Yearbook.University.Class do
  @moduledoc """
  A Class is a group of students that are in the same year and degree.
  """
  use Yearbook.Schema

  alias Yearbook.Accounts
  alias Yearbook.University

  schema "classes" do
    field :year, :integer
    belongs_to :academic_year, University.AcademicYear
    belongs_to :degree, University.Degree

    many_to_many :students, Accounts.User,
      join_through: University.ClassStudent,
      join_keys: [class_id: :id, student_id: :id]

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:year, :academic_year_id, :degree_id])
    |> validate_required([:year, :academic_year_id, :degree_id])
    |> validate_number(:year, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> unique_constraint([:academic_year_id, :degree_id, :year])
  end
end

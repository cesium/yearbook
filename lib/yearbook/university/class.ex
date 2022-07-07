defmodule Yearbook.University.Class do
  @moduledoc """
  A Class is a group of students that are in the same grade and degree.
  """
  use Yearbook.Schema

  alias Yearbook.University

  schema "classes" do
    field :grade, :integer
    belongs_to :academic_year, University.AcademicYear
    belongs_to :degree, University.Degree

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:grade, :academic_year_id, :degree_id])
    |> validate_required([:grade, :academic_year_id, :degree_id])
    |> validate_number(:grade, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
  end
end

defmodule Yearbook.University.AcademicYear do
  @moduledoc """
  An academic year that defines a graduation year.
  """
  use Yearbook.Schema

  schema "academic_years" do
    field :start, :integer
    field :finish, :integer

    timestamps()
  end

  @doc false
  @required_fields ~w(start finish)a
  @optional_fields []
  def changeset(academic_year, attrs) do
    academic_year
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

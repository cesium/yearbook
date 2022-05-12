defmodule Yearbook.University.AcademicYear do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "academic_years" do
    field :finish, :integer
    field :start, :integer

    timestamps()
  end

  @doc false
  def changeset(academic_year, attrs) do
    academic_year
    |> cast(attrs, [:start, :finish])
    |> validate_required([:start, :finish])
  end
end

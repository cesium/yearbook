defmodule Yearbook.University.ClassStudent do
  @moduledoc """
  This module is the relationship between students and the classes to which they
  belong.
  """
  use Yearbook.Schema

  alias Yearbook.Accounts
  alias Yearbook.University

  schema "classes_students" do
    belongs_to :class, University.Class
    belongs_to :student, Accounts.User

    timestamps()
  end

  @doc false
  def changeset(class_student, attrs) do
    class_student
    |> cast(attrs, [:class_id, :student_id])
    |> validate_required([:class_id, :student_id])
    |> unique_constraint([:class_id, :student_id])
  end
end


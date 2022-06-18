defmodule Yearbook.University.Degree do
  @moduledoc """
  A university degree where users are enrolled in.
  """
  use Yearbook.Schema

  schema "degrees" do
    field :name, :string
    field :cycle, :integer

    timestamps()
  end

  @doc false
  @required_fields ~w(name cycle)a
  @optional_fields []
  def changeset(degree, attrs) do
    degree
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:cycle, greater_than_or_equal_to: 1, less_than_or_equal_to: 3)
  end
end

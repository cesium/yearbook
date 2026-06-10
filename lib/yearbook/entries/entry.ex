defmodule Yearbook.Entries.Entry do
  @moduledoc """
  Schema for a yearbook entry.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(photo name text year)a
  @optional_fields ~w(status masters)a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "entries" do
    field :photo, :string
    field :name, :string
    field :text, :string
    field :status, Ecto.Enum, values: [:accepted, :pending, :denied], default: :pending
    field :masters, :boolean, default: false
    field :year, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(entry, attrs) do
    current_year = Date.utc_today().year

    entry
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:year, greater_than: 2020, less_than_or_equal_to: current_year)
    |> validate_length(:text, max: 200)
  end
end

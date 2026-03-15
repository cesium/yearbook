defmodule Yearbook.Entries.Entry do
  @moduledoc """
  Schema for a yearbook entry.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(photo name text)a
  @optional_fields ~w(status)a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "entries" do
    field :photo, :string
    field :name, :string
    field :text, :string
    field :status, Ecto.Enum, values: [:accepted, :pending, :denied], default: :pending

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

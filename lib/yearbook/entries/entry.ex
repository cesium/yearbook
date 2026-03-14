defmodule Yearbook.Entries.Entry do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attrs, [:photo, :name, :text, :status])
    |> validate_required([:photo, :name, :text])
  end
end

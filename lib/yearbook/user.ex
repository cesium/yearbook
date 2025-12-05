defmodule Yearbook.User do
  @moduledoc """
    Yearbook's user module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :email, :string
    field :year, Ecto.Enum, values: [:"1st", :"2nd", :"3rd", :"4th", :"5th"]
    field :password, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :year, :password])
    |> validate_required([:name, :email, :year, :password])
  end
end

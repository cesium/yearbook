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
    field :year, Ecto.Enum, values: [:"3rd", :"5th"]
    field :password, :string
    field :confirm_password, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc """
  A user changeset for registration.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:name, :email, :password, :confirm_password])
    |> validate_required([:name, :email, :password, :confirm_password])
    |> validate_name()
    |> validate_email(opts)
    |> validate_password()
    |> validate_password_confirmation()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :year])
    |> validate_required([:name, :email])
    |> validate_name()
    |> validate_email()
  end

  defp validate_name(changeset) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 160, message: "must be at least 2 characters")
  end

  defp validate_email(changeset, opts \\ []) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 72, message: "must be between 8 and 72 characters")
  end

  defp validate_password_confirmation(changeset) do
    password = get_change(changeset, :password)
    confirm_password = get_change(changeset, :confirm_password)

    if password && confirm_password && password != confirm_password do
      add_error(changeset, :confirm_password, "does not match password")
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Yearbook.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  Verifies the password.
  """
  def valid_password?(%Yearbook.User{password: user_password}, password)
      when is_binary(user_password) and byte_size(password) > 0 do
    user_password == password
  end

  def valid_password?(_, _) do
    false
  end
end

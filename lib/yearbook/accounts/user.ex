defmodule Yearbook.Accounts.User do
  @moduledoc """
  User schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(email new_password)a
  @optional_fields ~w(role confirmed_at)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :current_password, :string, virtual: true, redact: true
    field :new_password, :string, virtual: true, redact: true
    field :new_password_confirmation, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :utc_datetime
    field :role, Ecto.Enum, values: [:student, :admin], default: :student

    timestamps(type: :utc_datetime)
  end

  @doc """
  A changeset for registering a user with an email address and password.

  ## Options

    * `:validate_unique` - Set to false if you don't want to validate the
      uniqueness of the email, useful when displaying live validations.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, @required_fields)
    |> validate_email(opts)
    |> validate_confirmation(:new_password, required: true)
    |> validate_password(:new_password, opts)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_email([])
    |> validate_password(:new_password, [])
  end

  defp validate_email(changeset, opts) do
    changeset =
      changeset
      |> validate_required([:email])
      |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+$/,
        message: "must have the @ sign and no spaces"
      )
      |> validate_length(:email, max: 160)
      |> update_change(:email, &String.downcase/1)

    if Keyword.get(opts, :validate_unique, true) do
      changeset
      |> unsafe_validate_unique(:email, Yearbook.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the password.

  It is important to validate the length of the password, as long passwords may
  be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the new password so it can be stored securely
      in the database and ensures the `new_password` field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:new_password, :current_password])
    |> validate_confirmation(:new_password, required: true)
    |> validate_current_password()
    |> validate_password(:new_password, opts)
  end

  defp validate_current_password(changeset) do
    case get_change(changeset, :current_password) do
      current_password when is_binary(current_password) and current_password != "" ->
        if valid_password?(changeset.data, current_password) do
          changeset
        else
          add_error(changeset, :current_password, "does not match current password")
        end

      _ ->
        add_error(changeset, :current_password, "can't be blank")
    end
  end

  defp validate_password(changeset, field, opts) do
    changeset
    |> validate_required([field])
    |> validate_length(field, min: 12, max: 72)
    # Examples of additional password validation:
    # |> validate_format(:new_password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:new_password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:new_password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(field, opts)
  end

  defp maybe_hash_password(changeset, field, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    new_password = get_change(changeset, field)

    if hash_password? && new_password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(field, max: 72, count: :bytes)
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(new_password))
      |> delete_change(field)
    else
      changeset
    end
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = DateTime.utc_now(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Yearbook.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end
end

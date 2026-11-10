defmodule Yearbook.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Yearbook.Repo

  alias Yearbook.Accounts.{User, UserNotifier, UserToken}

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password) && user.confirmed_at, do: user
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for registering a user.

  See `Yearbook.Accounts.User.registration_changeset/3` for supported options.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(user, attrs \\ %{}, opts \\ []) do
    User.registration_changeset(user, attrs, opts)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  See `Yearbook.Accounts.User.password_changeset/3` for a list of supported options.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}, opts \\ []) do
    User.password_changeset(user, attrs, opts)
  end

  @doc "Returns a changeset for a password reset authorized by a valid email token."
  def change_user_reset_password(user, attrs \\ %{}, opts \\ []) do
    User.password_reset_changeset(user, attrs, opts)
  end

  @doc """
  Updates the user password.

  Returns a tuple with the updated user, as well as a list of expired tokens.

  ## Examples

      iex> update_user_password(user, %{new_password: ...})
      {:ok, {%User{}, [...]}}

      iex> update_user_password(user, %{new_password: "too short"})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, attrs) do
    user
    |> User.password_changeset(attrs)
    |> Ecto.Changeset.delete_change(:current_password)
    |> update_user_and_delete_all_tokens()
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.

  If the token is valid `{user, token_inserted_at}` is returned, otherwise `nil` is returned.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc "Gets the user associated with a valid email confirmation token."
  def get_user_by_confirmation_token(token) do
    with {:ok, query} <- UserToken.verify_confirmation_token_query(token),
         {user, _token} <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc "Confirms a user's email address with a valid confirmation token."
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_confirmation_token_query(token),
         {%User{confirmed_at: nil} = user, _token} <- Repo.one(query),
         {:ok, {confirmed_user, _expired_tokens}} <-
           user |> User.confirm_changeset() |> update_user_and_delete_all_tokens() do
      {:ok, confirmed_user}
    else
      _ -> {:error, :invalid_token}
    end
  end

  @doc "Delivers email confirmation instructions to a newly registered user."
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
    Repo.insert!(user_token)

    UserNotifier.deliver_user_confirmation_instructions(
      user,
      confirmation_url_fun.(encoded_token)
    )
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(from(UserToken, where: [token: ^token, context: "session"]))
    :ok
  end

  ## Token helper

  defp update_user_and_delete_all_tokens(changeset) do
    Repo.transact(fn ->
      with {:ok, user} <- Repo.update(changeset) do
        tokens_to_expire = Repo.all_by(UserToken, user_id: user.id)

        Repo.delete_all(from(t in UserToken, where: t.id in ^Enum.map(tokens_to_expire, & &1.id)))

        {:ok, {user, tokens_to_expire}}
      end
    end)
  end

  @doc "Delivers password reset instructions to the given user."
  def deliver_password_reset_instructions(%User{} = user, reset_url_fun)
      when is_function(reset_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)

    UserNotifier.deliver_password_reset_instructions(
      user,
      reset_url_fun.(encoded_token)
    )
  end

  @doc "Delivers password reset instructions when an account exists for the email."
  def forgot_password(email, reset_url_fun)
      when is_binary(email) and is_function(reset_url_fun, 1) do
    email = email |> String.trim() |> String.downcase()

    case get_user_by_email(email) do
      %User{} = user -> deliver_password_reset_instructions(user, reset_url_fun)
      nil -> :ok
    end
  end

  @doc "Gets the user associated with a valid password reset token."
  def get_user_by_password_reset_token(token) do
    with {:ok, query} <- UserToken.verify_password_reset_token_query(token),
         {user, _token} <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc "Resets a user's password with a valid, single-use reset token."
  def reset_user_password(token, attrs) do
    case UserToken.verify_password_reset_token_query(token) do
      {:ok, query} -> reset_password_with_token(query, attrs)
      :error -> {:error, :invalid_token}
    end
  end

  defp reset_password_with_token(query, attrs) do
    Repo.transact(fn ->
      case Repo.one(query) do
        {%User{} = user, %UserToken{} = reset_token} ->
          update_password_with_reset_token(user, reset_token, attrs)

        _ ->
          Repo.rollback(:invalid_token)
      end
    end)
  end

  defp update_password_with_reset_token(user, reset_token, attrs) do
    case Repo.delete_all(from(t in UserToken, where: t.id == ^reset_token.id)) do
      {1, _} -> update_password_and_delete_sessions(user, attrs)
      _ -> Repo.rollback(:invalid_token)
    end
  end

  defp update_password_and_delete_sessions(user, attrs) do
    case user |> User.password_reset_changeset(attrs) |> Repo.update() do
      {:ok, updated_user} ->
        tokens_to_expire = Repo.all_by(UserToken, user_id: user.id)

        Repo.delete_all(from(t in UserToken, where: t.id in ^Enum.map(tokens_to_expire, & &1.id)))

        {:ok, {updated_user, tokens_to_expire}}

      {:error, changeset} ->
        Repo.rollback(changeset)
    end
  end
end

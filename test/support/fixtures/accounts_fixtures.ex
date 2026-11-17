defmodule Yearbook.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Yearbook.Accounts` context.
  """

  import Ecto.Query

  alias Yearbook.Accounts
  alias Yearbook.Accounts.Scope

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      new_password: valid_user_password(),
      new_password_confirmation: valid_user_password()
    })
  end

  def unconfirmed_user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.register_user()

    user
  end

  def user_fixture(attrs \\ %{}) do
    user = unconfirmed_user_fixture(attrs)

    token =
      extract_user_token(fn url ->
        Accounts.deliver_user_confirmation_instructions(user, url)
      end)

    {:ok, user} = Accounts.confirm_user(token)

    user
  end

  def user_scope_fixture do
    user = user_fixture()
    user_scope_fixture(user)
  end

  def user_scope_fixture(user) do
    Scope.for_user(user)
  end

  def set_password(user) do
    {:ok, {user, _expired_tokens}} =
      Accounts.update_user_password(user, %{
        current_password: valid_user_password(),
        new_password: valid_user_password(),
        new_password_confirmation: valid_user_password()
      })

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  def generate_user_confirmation_token(user) do
    {encoded_token, user_token} = Accounts.UserToken.build_email_token(user, "confirm")
    Yearbook.Repo.insert!(user_token)
    encoded_token
  end

  def offset_user_token(token, amount_to_add, unit) do
    dt = DateTime.add(DateTime.utc_now(:second), amount_to_add, unit)

    Yearbook.Repo.update_all(
      from(ut in Accounts.UserToken, where: ut.token == ^token),
      set: [inserted_at: dt]
    )
  end
end

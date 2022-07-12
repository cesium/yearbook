defmodule Yearbook.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Yearbook.Accounts` context.
  """

  alias Yearbook.Accounts
  alias Yearbook.Accounts.User

  def valid_user_name, do: "José Valim"
  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "Erlang-Elixir-Gleam!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      name: valid_user_name(),
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Yearbook.Accounts.register_user()

    user
  end

  def user_admin_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> user_fixture()
      |> Accounts.update_user_permissions(%{permissions: [:admin]}, %User{permissions: [:admin]})

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end

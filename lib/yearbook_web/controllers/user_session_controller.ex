defmodule YearbookWeb.UserSessionController do
  use YearbookWeb, :controller

  alias Yearbook.Accounts
  alias YearbookWeb.UserAuth

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  # email + password login
  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/users/log-in")
    end
  end

  def update_password(conn, %{"user" => user_params}) do
    user = conn.assigns.current_scope.user

    case Accounts.update_user_password(user, user_params) do
      {:ok, {updated_user, expired_tokens}} ->
        # disconnect all existing LiveViews with old sessions
        UserAuth.disconnect_sessions(expired_tokens)

        conn
        |> put_session(:user_return_to, ~p"/users/settings")
        |> put_flash(:info, "Password updated successfully!")
        |> UserAuth.log_in_user(updated_user, user_params)

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Could not update password. Check your entries and try again.")
        |> redirect(to: ~p"/users/settings")
    end
  end

  def confirm(conn, %{"user" => %{"token" => token}}) do
    case Accounts.confirm_user(token) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Email confirmed successfully. You can now log in.")
        |> redirect(to: ~p"/users/log-in")

      {:error, :invalid_token} ->
        conn
        |> put_flash(:error, "The confirmation link is invalid or has expired.")
        |> redirect(to: ~p"/users/log-in")
    end
  end

  def forgot(conn, %{"user" => user_params}) do
    %{"email" => email} = user_params

    _ =
      Accounts.forgot_password(
        email,
        &url(~p"/users/reset-password/#{&1}")
      )

    conn
    |> put_flash(
      :info,
      gettext(
        "If an account exists for that email, password reset instructions will be sent shortly."
      )
    )
    |> redirect(to: ~p"/users/log-in")
  end

  def reset_password(conn, %{"user" => %{"token" => token} = user_params}) do
    case Accounts.reset_user_password(token, user_params) do
      {:ok, {_user, expired_tokens}} ->
        UserAuth.disconnect_sessions(expired_tokens)

        conn
        |> put_flash(:info, gettext("Your password has been reset. You can now log in."))
        |> redirect(to: ~p"/users/log-in")

      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:error, gettext("Please check the new password and confirmation."))
        |> redirect(to: ~p"/users/reset-password/#{token}")

      {:error, :invalid_token} ->
        conn
        |> put_flash(:error, gettext("This password reset link is invalid or has expired."))
        |> redirect(to: ~p"/users/log-in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end

defmodule YearbookWeb.UserSessionController do
  use YearbookWeb, :controller

  alias Yearbook.Accounts
  alias YearbookWeb.Plugs.Auth

  plug :put_layout, {YearbookWeb.LayoutView, "full.html"}

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      Auth.log_in_user(conn, user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> Auth.log_out_user()
  end
end

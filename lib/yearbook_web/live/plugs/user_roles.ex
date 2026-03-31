defmodule YearbookWeb.Plugs.UserRoles do
  @moduledoc """
  Plugs for user type verification.
  """
  use YearbookWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  @doc """
  Used for routes that require the user to be admin.
  """
  def require_admin_user(conn, _opts) do
    require_user_type(conn, :admin)
  end

  defp require_user_type(conn, role) do
    user = conn.assigns[:current_scope] && conn.assigns.current_scope.user

    if user && user.role == role do
      conn
    else
      conn
      |> put_flash(:error, "You don't have access to this page.")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end

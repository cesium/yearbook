defmodule YearbookWeb.UserAuth do
  @moduledoc """
  Simple authentication for LiveView using socket assigns.
  """

  import Phoenix.Component
  import Phoenix.LiveView

  @doc """
  Handles mounting and authenticating the current_user in LiveViews.
  """
  def on_mount(:ensure_authenticated, params, _session, socket) do
    socket = assign_current_user(socket, params)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      socket =
        socket
        |> put_flash(:error, "You must log in to access this page.")
        |> redirect(to: "/signin")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_user_is_authenticated, params, _session, socket) do
    socket = assign_current_user(socket, params)

    if socket.assigns.current_user do
      {:halt, redirect(socket, to: "/home")}
    else
      {:cont, socket}
    end
  end

  def on_mount(:mount_current_user, params, _session, socket) do
    {:cont, assign_current_user(socket, params)}
  end

  defp assign_current_user(socket, params) do
    assign_new(socket, :current_user, fn ->
      if user_id = params["user_id"] do
        Yearbook.Users.get_user!(user_id)
      end
    end)
  end
end

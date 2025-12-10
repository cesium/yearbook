defmodule YearbookWeb.SignUpLive.Index do
  use YearbookWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:password_visible, false)

    {:ok, socket}
  end

  # Para o campo Password
  def toggle_password_visibility(js \\ %JS{}) do
    js
    |> JS.toggle_attribute({"type", "password", "text"}, to: "#password-input")
    |> JS.toggle_class("hero-eye", to: "#toggle-eye-password")
    |> JS.toggle_class("hero-eye-slash", to: "#toggle-eye-password")
  end

  # Para o campo Confirm Password
  def toggle_confirm_password_visibility(js \\ %JS{}) do
    js
    |> JS.toggle_attribute({"type", "password", "text"}, to: "#reenterPassword-input")
    |> JS.toggle_class("hero-eye", to: "#toggle-eye-confirm")
    |> JS.toggle_class("hero-eye-slash", to: "#toggle-eye-confirm")
  end
end

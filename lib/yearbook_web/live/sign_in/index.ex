defmodule YearbookWeb.SignInLive.Index do
  use YearbookWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:password_visible, false)

    {:ok, socket}
  end

  def toggle_password_visibility(js \\ %JS{}) do
    js
    |> JS.toggle_attribute({"type", "password", "text"}, to: "#password-input")
    |> JS.toggle_class("hero-eye", to: "#toggle-eye-password")
    |> JS.toggle_class("hero-eye-slash", to: "#toggle-eye-password")
  end
end

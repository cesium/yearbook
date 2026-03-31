defmodule YearbookWeb.Navbar do
  @moduledoc """
  Navbar component.
  """
  use YearbookWeb, :html
  alias Phoenix.LiveView.JS

  attr :current_scope, :any, default: nil

  def navbar(assigns) do
    ~H"""
    <div class="bg-white flex items-center justify-between w-full h-16 sm:h-20 px-3 sm:px-4 border-b-2 border-primary sticky top-0 z-40">
      <div class="flex z-10 justify-between h-full items-center">
        <div class="p-2 sm:p-3 rounded-2xl">
          <.link navigate={~p"/"} class="flex items-center gap-2 sm:gap-3 cursor-pointer">
            <span class="hero-academic-cap text-black h-7 w-7 sm:h-8 sm:w-8"></span>
            <span class="text-xl sm:text-2xl font-bold text-black uppercase">YEARBOOK</span>
          </.link>
        </div>
      </div>

      <div class="hidden lg:flex items-center gap-1 sm:gap-3">
        <.nav_content current_scope={@current_scope} />
      </div>

      <div class="lg:hidden flex items-center">
        <button type="button" phx-click={show_mobile_navbar()} id="show-mobile-navbar">
          <.icon name="hero-bars-3" class="size-8 text-black" />
        </button>
      </div>
    </div>

    <div
      id="mobile-navbar-container"
      class="fixed inset-0 z-50 lg:hidden"
      style="display: none;"
    >
      <div class="fixed inset-0 bg-black/20" phx-click={hide_mobile_navbar()}></div>

      <div
        id="mobile-navbar"
        class="relative bg-white border-b-2 border-primary w-full flex flex-col p-4 shadow-lg"
      >
        <div class="flex justify-end mb-4">
          <button type="button" phx-click={hide_mobile_navbar()}>
            <.icon name="hero-x-mark" class="size-8 text-black" />
          </button>
        </div>

        <div class="flex flex-col items-center gap-4 pb-4">
          <.nav_content current_scope={@current_scope} is_mobile={true} />
        </div>
      </div>
    </div>
    """
  end

  defp nav_content(assigns) do
    assigns = assign_new(assigns, :is_mobile, fn -> false end)

    ~H"""
    <%= if @current_scope && @current_scope.user do %>
      <%= if @current_scope.user.role == :admin do %>
        <.link
          navigate={~p"/backoffice/approvals"}
          phx-click={@is_mobile && hide_mobile_navbar()}
          class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-bold text-primary hover:opacity-80 transition cursor-pointer"
        >
          Backoffice
        </.link>
      <% end %>
      <.link
        navigate={~p"/users/settings"}
        phx-click={@is_mobile && hide_mobile_navbar()}
        class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-semibold hover:text-primary transition cursor-pointer"
      >
        Settings
      </.link>
      <.link
        href={~p"/users/log-out"}
        method="delete"
        class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-semibold hover:text-primary transition cursor-pointer"
      >
        Logout
      </.link>
    <% else %>
      <.link
        navigate={~p"/users/register"}
        phx-click={@is_mobile && hide_mobile_navbar()}
        class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-semibold hover:text-primary transition cursor-pointer"
      >
        Sign Up
      </.link>
      <.link
        navigate={~p"/users/log-in"}
        phx-click={@is_mobile && hide_mobile_navbar()}
        class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-semibold hover:text-primary transition cursor-pointer"
      >
        Sign In
      </.link>
    <% end %>
    """
  end

  def show_mobile_navbar(js \\ %JS{}) do
    js
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.show(to: "#mobile-navbar-container", transition: "fade-in")
    |> JS.show(
      to: "#mobile-navbar",
      display: "flex",
      time: 300,
      transition:
        {"transition ease-in-out duration-300 transform", "-translate-y-full", "translate-y-0"}
    )
  end

  def hide_mobile_navbar(js \\ %JS{}) do
    js
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.hide(to: "#mobile-navbar-container", transition: "fade-out")
    |> JS.hide(
      to: "#mobile-navbar",
      time: 300,
      transition:
        {"transition ease-in-out duration-300 transform", "translate-y-0", "-translate-y-full"}
    )
  end
end

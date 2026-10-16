defmodule YearbookWeb.Navbar do
  @moduledoc """
  Navbar component.
  """
  use YearbookWeb, :html
  alias Phoenix.LiveView.JS

  attr :current_scope, :any, default: nil

  def navbar(assigns) do
    ~H"""
    <div class="sticky top-0 z-40 w-full border-b border-gray-100 bg-white">
      <div class="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-12 flex h-16 sm:h-20 items-center justify-between">
        <div class="flex items-center">
          <.link navigate={~p"/"} class="flex items-center gap-2 sm:gap-3 cursor-pointer">
            <span class="hero-academic-cap text-black h-7 w-7 sm:h-8 sm:w-8"></span>
          </.link>
        </div>

        <div class="hidden lg:flex items-center flex-1 ml-6">
          <.nav_links current_scope={@current_scope} />

          <div class="flex-1"></div>

          <.user_profile current_scope={@current_scope} />
        </div>
        <div class="lg:hidden flex items-center">
          <button type="button" phx-click={show_mobile_navbar()} id="show-mobile-navbar">
            <.icon name="hero-bars-3" class="size-8 text-black" />
          </button>
        </div>
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
          <.nav_links current_scope={@current_scope} is_mobile={true} />
          <hr class="w-full border-gray-100 my-2" />
          <.user_profile current_scope={@current_scope} is_mobile={true} />
        </div>
      </div>
    </div>
    """
  end

  defp nav_links(assigns) do
    assigns = assign_new(assigns, :is_mobile, fn -> false end)

    ~H"""
    <.link
      navigate={~p"/yearbook"}
      phx-click={@is_mobile && hide_mobile_navbar()}
      class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-orbitron hover:text-main transition cursor-pointer"
    >
      {gettext("Percursos")}
    </.link>

    <.link
      navigate={~p"/request"}
      phx-click={@is_mobile && hide_mobile_navbar()}
      class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-orbitron hover:text-main transition cursor-pointer"
    >
      {gettext("Pedido")}
    </.link>

    <%= if @current_scope && @current_scope.user && @current_scope.user.role == :admin do %>
      <.link
        navigate={~p"/backoffice/approvals"}
        phx-click={@is_mobile && hide_mobile_navbar()}
        class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-orbitron hover:text-main hover:opacity-80 transition cursor-pointer"
      >
        {gettext("Backoffice")}
      </.link>
    <% end %>
    """
  end

  defp user_profile(assigns) do
    assigns = assign_new(assigns, :is_mobile, fn -> false end)

    ~H"""
    <%= if @current_scope && @current_scope.user do %>
      <%= if @is_mobile do %>
        <.link
          navigate={~p"/users/settings"}
          phx-click={hide_mobile_navbar()}
          class="block w-full px-4 py-2 text-center text-sm font-orbitron rounded-xl hover:bg-gray-100"
        >
          {gettext("Definições")}
        </.link>

        <.link
          href={~p"/users/log-out"}
          method="delete"
          phx-click={hide_mobile_navbar()}
          class="block w-full px-4 py-2 text-center text-sm font-orbitron text-main rounded-xl hover:bg-red-50"
        >
          {gettext("Terminar sessão")}
        </.link>
      <% else %>
        <div class="relative inline-block text-left" phx-click-away={hide_user_menu()}>
          <button
            type="button"
            phx-click={show_user_menu()}
            class="flex items-center justify-center p-1 rounded-full hover:bg-gray-100 transition"
          >
            <span class="hero-user-circle-solid text-black h-7 w-7 sm:h-8 sm:w-8"></span>
          </button>

          <div
            id="user-menu-dropdown"
            class="hidden absolute right-0 mt-2 w-48 rounded-2xl bg-white p-2 border border-gray-300 z-50 flex flex-col gap-1"
          >
            <.link
              navigate={~p"/users/settings"}
              phx-click={hide_user_menu()}
              class="block w-full px-4 py-2 text-sm font-orbitron rounded-xl hover:bg-gray-100"
            >
              {gettext("Definições")}
            </.link>

            <.link
              href={~p"/users/log-out"}
              method="delete"
              phx-click={hide_user_menu()}
              class="block w-full px-4 py-2 text-sm font-orbitron text-main rounded-xl hover:bg-red-50"
            >
              {gettext("Terminar sessão")}
            </.link>
          </div>
        </div>
      <% end %>
    <% else %>
      <.link
        navigate={~p"/users/register"}
        phx-click={@is_mobile && hide_mobile_navbar()}
        class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-semibold hover:text-main transition cursor-pointer"
      >
        {gettext("Registar-se")}
      </.link>
      <.link
        navigate={~p"/users/log-in"}
        phx-click={@is_mobile && hide_mobile_navbar()}
        class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-semibold hover:text-main transition cursor-pointer"
      >
        {gettext("Iniciar sessão")}
      </.link>
    <% end %>
    """
  end

  def show_user_menu(js \\ %JS{}) do
    js
    |> JS.toggle(
      to: "#user-menu-dropdown",
      display: "flex",
      in:
        {"transition ease-out duration-100", "transform opacity-0 scale-95",
         "transform opacity-100 scale-100"},
      out:
        {"transition ease-in duration-75", "transform opacity-100 scale-100",
         "transform opacity-0 scale-95"}
    )
  end

  def hide_user_menu(js \\ %JS{}) do
    js
    |> JS.hide(
      to: "#user-menu-dropdown",
      transition:
        {"transition ease-in duration-75", "transform opacity-100 scale-100",
         "transform opacity-0 scale-95"}
    )
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

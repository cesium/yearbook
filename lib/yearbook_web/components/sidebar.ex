defmodule YearbookWeb.Sidebar do
  @moduledoc """
  Sidebar component for the application layout.
  """
  use Phoenix.Component
  use YearbookWeb, :html
  alias Phoenix.LiveView.JS

  attr :pages, :list, required: true
  attr :current_page, :atom, default: nil

  def sidebar(assigns) do
    ~H"""
    <div class="lg:hidden bg-white flex items-center justify-between w-full h-16 sm:h-20 px-3 sm:px-4 border-b-2 border-primary sticky top-0 z-40">
      <div class="flex z-10 justify-between h-full items-center">
        <div class="p-2 sm:p-3 rounded-2xl">
          <.link navigate={~p"/"} class="flex items-center gap-2 sm:gap-3 cursor-pointer">
            <span class="hero-academic-cap text-black h-7 w-7 sm:h-8 sm:w-8"></span>
            <span class="text-xl sm:text-2xl font-bold text-black uppercase">YEARBOOK</span>
          </.link>
        </div>
      </div>

      <div class="flex items-center">
        <button type="button" phx-click={show_mobile_sidebar()}>
          <.icon name="hero-bars-3" class="size-8 text-black" />
        </button>
      </div>
    </div>

    <div
      id="mobile-sidebar-container"
      class="fixed inset-0 z-50 flex lg:hidden"
      aria-modal="true"
      style="display: none;"
    >
      <div
        id="sidebar-overlay"
        class="fixed inset-0 bg-black/20"
        phx-click={hide_mobile_sidebar()}
      >
      </div>
      <div
        id="mobile-sidebar"
        class="relative w-64 bg-white border-r border-black/10 h-full flex flex-col"
      >
        <div class="p-4 flex justify-end">
          <button phx-click={hide_mobile_sidebar()}>
            <.icon name="hero-x-mark" class="size-6" />
          </button>
        </div>
        <.sidebar_content pages={@pages} current_page={@current_page} />
      </div>
    </div>

    <aside class="hidden lg:flex w-64 h-screen bg-white flex-col border-r border-black/10 sticky top-0">
      <.sidebar_content pages={@pages} current_page={@current_page} />
    </aside>
    """
  end

  defp sidebar_content(assigns) do
    ~H"""
    <div class="font-bold text-3xl p-10 flex justify-center">
      <.link navigate={~p"/"} class="uppercase">YEARBOOK</.link>
    </div>

    <nav class="flex flex-col px-5 gap-2">
      <%= for page <- @pages do %>
        <.link
          navigate={page.url}
          phx-click={hide_mobile_sidebar()}
          class={[
            "flex items-center gap-2 w-full px-3 h-10 rounded-md transition-colors",
            @current_page == page.key && "bg-black text-white",
            @current_page != page.key && "hover:bg-gray-100"
          ]}
        >
          <.icon name={page.icon} class="size-4.5" />
          <span class="text-md">{page.title}</span>
        </.link>
      <% end %>
    </nav>
    """
  end

  def show_mobile_sidebar(js \\ %JS{}) do
    js
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.show(
      to: "#mobile-sidebar-container",
      transition: {"transition fade-in duration-200", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "#mobile-sidebar",
      display: "flex",
      time: 300,
      transition:
        {"transition ease-in-out duration-300 transform", "-translate-x-full", "translate-x-0"}
    )
    |> JS.hide(to: "#show-mobile-sidebar", transition: "fade-out")
    |> JS.dispatch("js:call", to: "#hide-mobile-sidebar", detail: %{call: "focus", args: []})
  end

  def hide_mobile_sidebar(js \\ %JS{}) do
    js
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.hide(
      to: "#mobile-sidebar-container",
      transition: {"transition fade-out duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.hide(
      to: "#mobile-sidebar",
      time: 300,
      transition:
        {"transition ease-in-out duration-300 transform", "translate-x-0", "-translate-x-full"}
    )
    |> JS.show(to: "#show-mobile-sidebar", transition: "fade-in")
    |> JS.dispatch("js:call", to: "#show-mobile-sidebar", detail: %{call: "focus", args: []})
  end
end

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
    <div class="lg:hidden p-4 border-b border-black/10 bg-white flex justify-between items-center">
      <span class="font-bold text-xl uppercase tracking-tight">Yearbook</span>
      <button type="button" phx-click={show_mobile_sidebar()}>
        <.icon name="hero-bars-3" class="size-6" />
      </button>
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
    <div class="font-bold text-3xl p-10 flex justify-center">YEARBOOK</div>

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
    |> JS.show(to: "#mobile-sidebar-container")
    |> JS.add_class("overflow-hidden", to: "body")
  end

  def hide_mobile_sidebar(js \\ %JS{}) do
    js
    |> JS.hide(to: "#mobile-sidebar-container")
    |> JS.remove_class("overflow-hidden", to: "body")
  end
end

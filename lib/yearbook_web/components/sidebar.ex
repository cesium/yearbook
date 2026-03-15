defmodule YearbookWeb.Sidebar do
  @moduledoc """
  Sidebar component for the application layout.
  """

  use Phoenix.Component
  use YearbookWeb, :html

  attr :pages, :list, required: true
  attr :current_page, :atom, default: nil

  def sidebar(assigns) do
    ~H"""
    <aside class="w-64 h-screen bg-white flex flex-col border-r border-black/10">
      <div class="font-bold text-3xl p-10 flex justify-center">YEARBOOK</div>

      <nav class="flex flex-col px-5 gap-2">
        <%= for page <- @pages do %>
          <.link
            navigate={page.url}
            class={[
              "flex items-center gap-2 w-full px-3 h-10 rounded-md transition-colors",
              @current_page == page.key && "bg-black text-white",
              @current_page != page.key && "hover:bg-gray-100"
            ]}
          >
            <.icon name={page.icon} class="size-4.5"/>
            <span class="text-md">{page.title}</span>
          </.link>
        <% end %>
      </nav>
    </aside>
    """
  end
end

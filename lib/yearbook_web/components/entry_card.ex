defmodule YearbookWeb.Components.EntryCard do
  @moduledoc """
  Entry Card Component.
  """
  use Phoenix.Component
  import YearbookWeb.Components.Avatar

  attr :src, :string, default: nil, doc: "The URL of the image to display."
  attr :name, :string, doc: "The name of the user."
  attr :text, :string, default: nil, doc: "Text."

  def entry_card(assigns) do
    ~H"""
    <div class="flex flex-col items-center gap-3 p-4 bg-white rounded-2xl border border-gray-100 w-full h-full transition-all">
      <div class="w-full aspect-square overflow-hidden rounded-xl border border-gray-50">
        <%= if @src do %>
          <img src={@src} alt={@name} class="w-full h-full object-cover" />
        <% else %>
          <div class="flex items-center justify-center w-full h-full bg-gray-100 text-gray-400 font-bold text-xl">
            {get_initials(@name)}
          </div>
        <% end %>
      </div>

      <div class="text-center w-full">
        <h1 class="font-bold text-gray-900 text-sm md:text-base leading-tight">
          {@name}
        </h1>
        <p class="italic text-[11px] md:text-xs text-gray-500 mt-2 line-clamp-3 leading-relaxed">
          "{@text}"
        </p>
      </div>
    </div>
    """
  end
end

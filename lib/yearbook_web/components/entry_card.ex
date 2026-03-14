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
    <div class="flex flex-col items-center gap-2 p-2 overflow-auto bg-white rounded-xl shadow-md w-full min-h-56 sm:min-h-72 lg:min-h-96">
      <div class="w-full shrink-0 overflow-hidden aspect-square sm:aspect-4/3">
        <%= if @src do %>
          <img
            src={@src}
            alt={@name}
            class="w-full h-full object-cover rounded-md"
          />
        <% else %>
          <div class="flex items-center justify-center w-full h-full rounded-xl bg-gray-300 text-white font-bold text-2xl">
            {get_initials(@name)}
          </div>
        <% end %>
      </div>
      <h1 class="text-center w-full wrap-break-word font-bold px-2 text-md sm:text-lg lg:text-xl">
        {@name}
      </h1>
      <p class="flex-1 place-items-center p-2 text-sm sm:text-md lg:text-lg">{@text}</p>
    </div>
    """
  end
end

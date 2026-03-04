defmodule YearbookWeb.Components.EntryCard do
  @moduledoc """
  Entry Card Component.
  """
  use Phoenix.Component
  import YearbookWeb.Components.Avatar

  attr :src, :string, default: nil, doc: "The URL of the image to display."
  attr :name, :string, doc: "The name of the user."
  attr :text, :string, default: nil, doc: "Text."
  attr :size, :string, default: "md", values: ["sm", "md", "lg"], doc: "Card size."

  def entryCard(assigns) do
    ~H"""
    <div class={"flex flex-col items-center gap-2 overflow-auto bg-white rounded-xl shadow-md #{size_class(@size)}"}>
      <div class="w-full shrink-0 h-3/5 p-2 overflow-hidden">
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
      <h1 class="text-center mx-auto max-w-[90%] font-bold text-xl">{@name}</h1>
      <p class="flex-1 text-justify mx-auto px-2 pb-2">{@text}</p>
    </div>
    """
  end

  defp size_class("sm"), do: "w-36 h-64"
  defp size_class("md"), do: "w-48 h-84"
  defp size_class("lg"), do: "w-64 h-108"
  defp size_class(_), do: size_class("md")
end

defmodule YearbookWeb.Components.Avatar do
  @moduledoc """
  Avatar Component.
  """

  use Phoenix.Component

  attr :src, :string, default: nil, doc: "The URL of the image to display."

  attr :size, :atom,
    values: [:xs, :sm, :md, :lg, :xl],
    default: :md,
    doc: "The size of the avatars."

  attr :name, :string, doc: "The name of the user."

  def avatar(%{src: nil} = assigns) do
    assigns = assigns |> assign(:size_classes, size_classes(assigns.size))

    ~H"""
    <div class={"avatar avatar--#{@size} #{@size_classes} flex items-center justify-center rounded-full bg-gray-300 text-white font-medium"}>
      {get_initials(@name)}
    </div>
    """
  end

  def avatar(assigns) do
    assigns = assigns |> assign(:size_classes, size_classes(assigns.size))

    ~H"""
    <img
      src={@src}
      alt={@name}
      class={"avatar avatar--#{@size} #{@size_classes} rounded-full object-fit"}
    />
    """
  end

  def size_classes(size) do
    case size do
      :xs -> "w-8 h-8 text-xs"
      :sm -> "w-12 h-12 text-sm"
      :md -> "w-16 h-16 text-base"
      :lg -> "w-24 h-24 text-xl"
      :xl -> "w-32 h-32 text-4xl"
    end
  end

  def get_initials(nil), do: "?"

  def get_initials(name) do
    parts = name |> String.split(" ", trim: true) |> Enum.reject(&(&1 == ""))

    case parts do
      [single] ->
        String.first(single) |> String.upcase()

      _ ->
        first = parts |> List.first() |> String.first() |> String.upcase()
        last = parts |> List.last() |> String.first() |> String.upcase()
        first <> last
    end
  end
end

defmodule YearbookWeb.Components.Logo do
  use YearbookWeb, :html

  attr :variant, :atom, values: [:color, :grey], default: :color
  attr :size, :atom, values: [:sm, :md, :lg], default: :md
  attr :class, :string, default: nil

  def logo(assigns) do
    ~H"""
    <img
      src={logo_src(@variant)}
      alt="Yearbook"
      class={["logo", "logo--#{@variant}", "w-auto", size_classes(@size), @class]}
    />
    """
  end

  defp logo_src(:color), do: ~p"/images/Logo.svg"
  defp logo_src(:grey), do: ~p"/images/Logo-grey.svg"

  defp size_classes(:sm), do: "h-8"
  defp size_classes(:md), do: "h-16"
  defp size_classes(:lg), do: "h-32"
end

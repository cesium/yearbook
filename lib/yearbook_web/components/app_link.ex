defmodule YearbookWeb.Components.AppLink do
  @moduledoc """
  A generalized link component with distinct visual variants.
  """

  use YearbookWeb, :html

  attr :href, :string, required: true
  attr :variant, :atom, default: :default, values: [:default, :secondary]
  attr :target, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def app_link(%{variant: :default} = assigns) do
    ~H"""
    <a
      href={@href}
      target={@target}
      class={[
        "inline-flex items-center gap-2 px-4 py-2",
        "text-black text-sm font-normal",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
      <span class="text-base leading-none">→</span>
    </a>
    """
  end

  def app_link(%{variant: :secondary} = assigns) do
    ~H"""
    <a
      href={@href}
      target={@target || "_blank"}
      rel="noopener noreferrer"
      class={[
        "inline-flex items-center gap-2 px-4 py-2",
        "text-orange-400 text-sm font-normal",
        "hover:border-orange-400 hover:bg-orange-400/5",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
      <span class="text-base leading-none">↗</span>
    </a>
    """
  end
end

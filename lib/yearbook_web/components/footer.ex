defmodule YearbookWeb.Footer do
  @moduledoc """
  Footer component.
  """

  use Phoenix.Component

  def footer(assigns) do
    ~H"""
    <footer class="p-4">
      <div class="flex items-center">
        <img
          src="/images/cesium.svg"
          alt="logo"
          class="h-10 w-auto"
        />
      </div>
    </footer>
    """
  end
end

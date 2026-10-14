defmodule YearbookWeb.Footer do
  @moduledoc """
  Footer component.
  """

  use YearbookWeb, :html

  def footer(assigns) do
    ~H"""
    <footer class="w-full shrink-0 border-t border-gray-100 bg-black py-8 lg:py-10 mt-10">
      <div class="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-12 flex flex-col">
        <img
          src={~p"/images/cesium.svg"}
          alt="logo"
          class="h-10 w-auto mb-4"
        />
        <.link navigate={~p"/privacy-policy"} class="text-white">
          <span>{gettext("Política de Privacidade")}</span>
        </.link>
      </div>
    </footer>
    """
  end
end

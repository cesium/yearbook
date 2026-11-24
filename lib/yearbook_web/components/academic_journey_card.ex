defmodule YearbookWeb.Components.AcademicJourneyCard do

  use Phoenix.Component
  import YearbookWeb.CoreComponents, only: [button: 1, icon: 1]

  attr :title, :string, default: ""
  attr :description, :string, default: ""
  attr :button_name, :string, default: ""
  attr :link, :string, default: ""

  def card(assigns) do
    ~H"""
    <div class="w-3/4 bg-red-100/50 rounded-md outline-2 outline-orange-300/35 p-5">
      <div class="pt-2 pb-1 text-main font-orbitron text-2xl font-semibold">
        {@title}
      </div>
      <div class="pb-10 pr-10 text-black/75">
        {@description}
      </div>
      <div class="flex justify-end mr-3">
        <.button class="text-main font-medium cursor-pointer group hover:text-black transition duration-500 ease-in-out" navigate={@link} >
          {@button_name}
          <.icon class="text-black group-hover:text-main transition duration-500 ease-in-out" name="hero-arrow-long-right" />
        </.button>
      </div>
    </div>
    """
  end
end

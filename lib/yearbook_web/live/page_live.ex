defmodule YearbookWeb.PageLive do
  use YearbookWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative h-screen w-full">
      <img
        src="/images/background.jpg"
        class="absolute inset-0 h-full w-full object-cover opacity-30 z-0"
        alt="background"
      />

      <div class="relative z-10 flex items-center justify-between w-full h-20 bg-black/2 backdrop-blur-xl px-6">
        <a href="/" class="flex items-center gap-3 cursor-pointer">
          <img src="/images/grad.svg" class="h-10 w-10" />
          <span class="text-2xl font-bold text-black">YEARBOOK</span>
        </a>
        <div class="flex items-center gap-2">
          <a href="/signup">
            <.button class="bg-gray-50 w-32 h-10 text-black">Sign Up</.button>
          </a>
          <a href="/signin">
            <.button class="bg-gray-50 w-32 h-10 text-black">Sign In</.button>
          </a>
        </div>
      </div>
    </div>
    """
  end
end

defmodule YearbookWeb.PageLive do
  use YearbookWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="relative h-screen w-full">
      <div class="relative z-10 flex items-center justify-between w-full h-20 bg-black/2 backdrop-blur-xl px-6">
        <div class="relative z-10 flex flex-col justify-between h-full p-6">
          <div class="bg-white/50 p-3 rounded-2xl ">
            <a href="/" class="flex items-center gap-3 cursor-pointer">
              <span class="hero-academic-cap text-black h-8 w-8"></span>
              <span class="text-2xl font-bold text-black">YEARBOOK</span>
            </a>
          </div>
        </div>
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

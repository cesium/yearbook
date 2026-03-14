defmodule YearbookWeb.HomeLive.Index do
  use YearbookWeb, :live_view

  on_mount {YearbookWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center h-full">
      <h1 class="text-2xl font-bold text-black">Welcome, {@current_user.name}!</h1>
    </div>
    """
  end
end

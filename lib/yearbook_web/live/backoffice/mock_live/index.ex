defmodule YearbookWeb.MockLive do
  use YearbookWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_page: :mock)}
  end

  def render(assigns) do
    ~H"""
      <div>Mock page</div>
    """
  end
end

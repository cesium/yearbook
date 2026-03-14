defmodule YearbookWeb.ApprovalLive do
  use YearbookWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_page: :approvals)}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-white p-6 rounded-2xl shadow">
      <h1 class="text-2xl font-bold mb-4 text-gray-800">Approvals</h1>
      <p class="text-gray-600">Mock page</p>
    </div>
    """
  end
end

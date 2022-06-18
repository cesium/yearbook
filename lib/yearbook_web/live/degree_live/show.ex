defmodule YearbookWeb.DegreeLive.Show do
  @moduledoc false
  use YearbookWeb, :live_view

  alias Yearbook.University

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:degree, University.get_degree!(id))}
  end

  defp page_title(:show), do: "Show Degree"
  defp page_title(:edit), do: "Edit Degree"
end

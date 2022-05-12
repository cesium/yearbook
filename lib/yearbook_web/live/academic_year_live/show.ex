defmodule YearbookWeb.AcademicYearLive.Show do
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
     |> assign(:academic_year, University.get_academic_year!(id))}
  end

  defp page_title(:show), do: "Show Academic year"
  defp page_title(:edit), do: "Edit Academic year"
end

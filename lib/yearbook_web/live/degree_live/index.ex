defmodule YearbookWeb.DegreeLive.Index do
  @moduledoc false
  use YearbookWeb, :live_view

  alias Yearbook.University
  alias Yearbook.University.Degree

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :degrees, list_degrees())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Degree")
    |> assign(:degree, University.get_degree!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Degree")
    |> assign(:degree, %Degree{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Degrees")
    |> assign(:degree, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    degree = University.get_degree!(id)
    {:ok, _} = University.delete_degree(degree)

    {:noreply, assign(socket, :degrees, list_degrees())}
  end

  defp list_degrees do
    University.list_degrees()
  end
end

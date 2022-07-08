defmodule YearbookWeb.Admin.AcademicYearLive.Index do
  @moduledoc false
  use YearbookWeb, :live_view

  alias Yearbook.University
  alias Yearbook.University.AcademicYear

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :academic_years, list_academic_years())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Academic year")
    |> assign(:academic_year, University.get_academic_year!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Academic year")
    |> assign(:academic_year, %AcademicYear{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Academic years")
    |> assign(:academic_year, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    academic_year = University.get_academic_year!(id)
    {:ok, _} = University.delete_academic_year(academic_year)

    {:noreply, assign(socket, :academic_years, list_academic_years())}
  end

  defp list_academic_years do
    University.list_academic_years()
  end
end

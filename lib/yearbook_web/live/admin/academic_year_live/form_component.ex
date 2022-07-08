defmodule YearbookWeb.Admin.AcademicYearLive.FormComponent do
  @moduledoc false
  use YearbookWeb, :live_component

  alias Yearbook.University

  @impl true
  def update(%{academic_year: academic_year} = assigns, socket) do
    changeset = University.change_academic_year(academic_year)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"academic_year" => academic_year_params}, socket) do
    changeset =
      socket.assigns.academic_year
      |> University.change_academic_year(academic_year_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"academic_year" => academic_year_params}, socket) do
    save_academic_year(socket, socket.assigns.action, academic_year_params)
  end

  defp save_academic_year(socket, :edit, academic_year_params) do
    case University.update_academic_year(socket.assigns.academic_year, academic_year_params) do
      {:ok, _academic_year} ->
        {:noreply,
         socket
         |> put_flash(:info, "Academic year updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_academic_year(socket, :new, academic_year_params) do
    case University.create_academic_year(academic_year_params) do
      {:ok, _academic_year} ->
        {:noreply,
         socket
         |> put_flash(:info, "Academic year created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

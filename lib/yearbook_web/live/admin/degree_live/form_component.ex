defmodule YearbookWeb.Admin.DegreeLive.FormComponent do
  @moduledoc false
  use YearbookWeb, :live_component

  alias Yearbook.University

  @impl true
  def update(%{degree: degree} = assigns, socket) do
    changeset = University.change_degree(degree)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"degree" => degree_params}, socket) do
    changeset =
      socket.assigns.degree
      |> University.change_degree(degree_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"degree" => degree_params}, socket) do
    save_degree(socket, socket.assigns.action, degree_params)
  end

  defp save_degree(socket, :edit, degree_params) do
    case University.update_degree(socket.assigns.degree, degree_params) do
      {:ok, _degree} ->
        {:noreply,
         socket
         |> put_flash(:info, "Degree updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_degree(socket, :new, degree_params) do
    case University.create_degree(degree_params) do
      {:ok, _degree} ->
        {:noreply,
         socket
         |> put_flash(:info, "Degree created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

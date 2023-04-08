defmodule YearbookWeb.YearbookLive.Show do
  @moduledoc false
  use YearbookWeb, :live_view

  alias Yearbook.University
  alias Yearbook.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("apply", _payload, socket) do
    attrs = %{
      "class_id" => socket.assigns.class.id,
      "student_id" => socket.assigns.current_user.id,
      "accepted" => false
    }

    case University.create_class_student(attrs) do
      {:ok, _class_student} ->
        {:noreply,
         socket
         |> put_flash(:info, "Applied to class successfully")
         |> push_redirect(to: Routes.class_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         assign(socket, :changeset, changeset)
         |> put_flash(:error, "You have already applied to this class")
         |> push_redirect(to: Routes.class_index_path(socket, :index))}
    end
  end

  @impl true
  def handle_params(%{"class_id" => id}, _, socket) do
    class = University.get_class!(id, [:students, :degree, :academic_year])

    {:noreply,
     socket
     |> assign(:page_title, class.degree.name)
     |> assign(:class, class)}
  end

  defp is_accepted?(student, class) do
    classes = University.list_student_classes(student)

    Enum.any?(classes, fn cs -> cs.accepted == true && cs.class_id == class end)
  end
end

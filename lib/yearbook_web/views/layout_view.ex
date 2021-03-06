defmodule YearbookWeb.LayoutView do
  use YearbookWeb, :view

  alias Yearbook.Uploaders

  @conn YearbookWeb.Endpoint

  defguard is_logged_in(assigns) when not is_nil(assigns.current_user)

  def navbar(assigns) when is_logged_in(assigns) do
    Enum.reduce(Enum.sort(assigns.current_user.permissions), [], fn role, acc ->
      acc ++ navbar(role)
    end)
  end

  def navbar(:admin) do
    [
      %{
        title: "Anos Letivos",
        path: Routes.admin_academic_year_index_path(@conn, :index)
      },
      %{
        title: "Cursos",
        path: Routes.admin_degree_index_path(@conn, :index)
      },
      %{
        title: "Turmas",
        path: Routes.admin_class_index_path(@conn, :index)
      }
    ]
  end

  def navbar(_assigns) do
    [
      %{
        title: "Contactos",
        path: Routes.page_path(@conn, :contacts)
      }
    ]
  end

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}
end

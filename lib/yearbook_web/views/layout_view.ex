defmodule YearbookWeb.LayoutView do
  use YearbookWeb, :view

  defguard is_logged_in(conn) when not is_nil(conn.assigns.current_user)

  def navbar(conn) when is_logged_in(conn) do
    [
      %{
        title: "Anos Letivos",
        path: Routes.admin_academic_year_index_path(YearbookWeb.Endpoint, :index)
      }
    ]
  end

  def navbar(_conn) do
    []
  end

  def footer do
    %{
      description: """
      O CeSIUM é o centro de estudantes que tem como missão representar e
      promover o curso de Engenharia Informática da Universidade do Minho.
      """,
      social: %{
        facebook: "https://facebook.com/cesiuminho",
        twitter: "https://twitter.com/cesiuminho",
        instagram: "https://intagram.com/cesiuminho",
        github: "https://github.com/cesium"
      }
    }
  end

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}
end

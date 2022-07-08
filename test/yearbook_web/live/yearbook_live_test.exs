defmodule YearbookWeb.YearbookLiveTest do
  use YearbookWeb.ConnCase

  import Phoenix.LiveViewTest
  import Yearbook.UniversityFixtures

  defp create_class(_) do
    degree = degree_fixture()
    class = class_fixture(%{degree_id: degree.id})
    %{class: class, degree: degree}
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_class]

    test "displays class", %{conn: conn, class: class, degree: degree} do
      {:ok, _show_live, html} = live(conn, Routes.yearbook_show_path(conn, :show, class))

      assert html =~ degree.name
    end
  end
end

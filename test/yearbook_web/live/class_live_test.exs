defmodule YearbookWeb.ClassLiveTest do
  use YearbookWeb.ConnCase

  import Phoenix.LiveViewTest
  import Yearbook.UniversityFixtures

  @update_attrs %{grade: 3}
  @invalid_attrs %{grade: nil}

  defp create_degree(_) do
    degree = degree_fixture()
    %{degree: degree}
  end

  defp create_academic_year(_) do
    academic_year = academic_year_fixture()
    %{academic_year: academic_year}
  end

  defp create_class(_) do
    class = class_fixture()
    %{class: class}
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_class, :create_degree, :create_academic_year]

    test "lists all classes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.admin_class_index_path(conn, :index))

      assert html =~ "Listing Classes"
    end

    test "saves new class", %{conn: conn, degree: degree, academic_year: academic_year} do
      {:ok, index_live, _html} = live(conn, Routes.admin_class_index_path(conn, :index))

      assert index_live |> element("a", "New Class") |> render_click() =~
               "New Class"

      assert_patch(index_live, Routes.admin_class_index_path(conn, :new))

      assert index_live
             |> form("#class-form", class: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#class-form",
          class: %{grade: 1, degree_id: degree.id, academic_year_id: academic_year.id}
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_class_index_path(conn, :index))

      assert html =~ "Class created successfully"
    end

    test "updates class in listing", %{conn: conn, class: class} do
      {:ok, index_live, _html} = live(conn, Routes.admin_class_index_path(conn, :index))

      assert index_live |> element("#class-#{class.id} a", "Edit") |> render_click() =~
               "Edit Class"

      assert_patch(index_live, Routes.admin_class_index_path(conn, :edit, class))

      assert index_live
             |> form("#class-form", class: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#class-form", class: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_class_index_path(conn, :index))

      assert html =~ "Class updated successfully"
    end

    test "deletes class in listing", %{conn: conn, class: class} do
      {:ok, index_live, _html} = live(conn, Routes.admin_class_index_path(conn, :index))

      assert index_live |> element("#class-#{class.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#class-#{class.id}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_class]

    test "displays class", %{conn: conn, class: class} do
      {:ok, _show_live, html} = live(conn, Routes.admin_class_show_path(conn, :show, class))

      assert html =~ "Show Class"
    end

    test "updates class within modal", %{conn: conn, class: class} do
      {:ok, show_live, _html} = live(conn, Routes.admin_class_show_path(conn, :show, class))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Class"

      assert_patch(show_live, Routes.admin_class_show_path(conn, :edit, class))

      assert show_live
             |> form("#class-form", class: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#class-form", class: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_class_show_path(conn, :show, class))

      assert html =~ "Class updated successfully"
    end
  end
end

defmodule YearbookWeb.AcademicYearLiveTest do
  use YearbookWeb.ConnCase

  import Phoenix.LiveViewTest
  import Yearbook.UniversityFixtures

  @create_attrs %{finish: 42, start: 42}
  @update_attrs %{finish: 43, start: 43}
  @invalid_attrs %{finish: nil, start: nil}

  defp create_academic_year(_) do
    academic_year = academic_year_fixture()
    %{academic_year: academic_year}
  end

  describe "Index" do
    setup [:create_academic_year]

    test "lists all academic_years", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.academic_year_index_path(conn, :index))

      assert html =~ "Listing Academic years"
    end

    test "saves new academic_year", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.academic_year_index_path(conn, :index))

      assert index_live |> element("a", "New Academic year") |> render_click() =~
               "New Academic year"

      assert_patch(index_live, Routes.academic_year_index_path(conn, :new))

      assert index_live
             |> form("#academic_year-form", academic_year: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#academic_year-form", academic_year: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.academic_year_index_path(conn, :index))

      assert html =~ "Academic year created successfully"
    end

    test "updates academic_year in listing", %{conn: conn, academic_year: academic_year} do
      {:ok, index_live, _html} = live(conn, Routes.academic_year_index_path(conn, :index))

      assert index_live |> element("#academic_year-#{academic_year.id} a", "Edit") |> render_click() =~
               "Edit Academic year"

      assert_patch(index_live, Routes.academic_year_index_path(conn, :edit, academic_year))

      assert index_live
             |> form("#academic_year-form", academic_year: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#academic_year-form", academic_year: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.academic_year_index_path(conn, :index))

      assert html =~ "Academic year updated successfully"
    end

    test "deletes academic_year in listing", %{conn: conn, academic_year: academic_year} do
      {:ok, index_live, _html} = live(conn, Routes.academic_year_index_path(conn, :index))

      assert index_live |> element("#academic_year-#{academic_year.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#academic_year-#{academic_year.id}")
    end
  end

  describe "Show" do
    setup [:create_academic_year]

    test "displays academic_year", %{conn: conn, academic_year: academic_year} do
      {:ok, _show_live, html} = live(conn, Routes.academic_year_show_path(conn, :show, academic_year))

      assert html =~ "Show Academic year"
    end

    test "updates academic_year within modal", %{conn: conn, academic_year: academic_year} do
      {:ok, show_live, _html} = live(conn, Routes.academic_year_show_path(conn, :show, academic_year))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Academic year"

      assert_patch(show_live, Routes.academic_year_show_path(conn, :edit, academic_year))

      assert show_live
             |> form("#academic_year-form", academic_year: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#academic_year-form", academic_year: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.academic_year_show_path(conn, :show, academic_year))

      assert html =~ "Academic year updated successfully"
    end
  end
end

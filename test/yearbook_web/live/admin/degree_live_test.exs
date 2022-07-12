defmodule YearbookWeb.Admin.DegreeLiveTest do
  use YearbookWeb.ConnCase

  import Phoenix.LiveViewTest
  import Yearbook.UniversityFixtures

  @create_attrs %{cycle: 2, name: "some name"}
  @update_attrs %{cycle: 3, name: "some updated name"}
  @invalid_attrs %{cycle: nil, name: nil}

  defp create_degree(_) do
    degree = degree_fixture()
    %{degree: degree}
  end

  describe "Index" do
    setup [:register_and_log_in_admin_user, :create_degree]

    test "lists all degrees", %{conn: conn, degree: degree} do
      {:ok, _index_live, html} = live(conn, Routes.admin_degree_index_path(conn, :index))

      assert html =~ "Listing Degrees"
      assert html =~ degree.name
    end

    test "saves new degree", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.admin_degree_index_path(conn, :index))

      assert index_live |> element("a", "New Degree") |> render_click() =~
               "New Degree"

      assert_patch(index_live, Routes.admin_degree_index_path(conn, :new))

      assert index_live
             |> form("#degree-form", degree: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#degree-form", degree: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_degree_index_path(conn, :index))

      assert html =~ "Degree created successfully"
      assert html =~ "some name"
    end

    test "updates degree in listing", %{conn: conn, degree: degree} do
      {:ok, index_live, _html} = live(conn, Routes.admin_degree_index_path(conn, :index))

      assert index_live |> element("#degree-#{degree.id} a", "Edit") |> render_click() =~
               "Edit Degree"

      assert_patch(index_live, Routes.admin_degree_index_path(conn, :edit, degree))

      assert index_live
             |> form("#degree-form", degree: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#degree-form", degree: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_degree_index_path(conn, :index))

      assert html =~ "Degree updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes degree in listing", %{conn: conn, degree: degree} do
      {:ok, index_live, _html} = live(conn, Routes.admin_degree_index_path(conn, :index))

      assert index_live |> element("#degree-#{degree.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#degree-#{degree.id}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_admin_user, :create_degree]

    test "displays degree", %{conn: conn, degree: degree} do
      {:ok, _show_live, html} = live(conn, Routes.admin_degree_show_path(conn, :show, degree))

      assert html =~ "Show Degree"
      assert html =~ degree.name
    end

    test "updates degree within modal", %{conn: conn, degree: degree} do
      {:ok, show_live, _html} = live(conn, Routes.admin_degree_show_path(conn, :show, degree))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Degree"

      assert_patch(show_live, Routes.admin_degree_show_path(conn, :edit, degree))

      assert show_live
             |> form("#degree-form", degree: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#degree-form", degree: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_degree_show_path(conn, :show, degree))

      assert html =~ "Degree updated successfully"
      assert html =~ "some updated name"
    end
  end
end

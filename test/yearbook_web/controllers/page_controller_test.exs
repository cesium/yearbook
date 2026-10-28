defmodule YearbookWeb.PageControllerTest do
  use YearbookWeb.ConnCase

  test "GET / renders the home page when logged out", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Licenciatura"
  end

  describe "when logged in" do
    setup :register_and_log_in_user

    test "GET / renders the home page", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert html_response(conn, 200) =~ "Licenciatura"
    end
  end
end

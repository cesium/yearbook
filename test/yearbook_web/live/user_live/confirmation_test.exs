defmodule YearbookWeb.UserLive.ConfirmationTest do
  use YearbookWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Yearbook.AccountsFixtures

  alias Yearbook.Accounts

  describe "email confirmation" do
    test "renders confirmation page for a valid token", %{conn: conn} do
      user = unconfirmed_user_fixture()
      token = generate_user_confirmation_token(user)

      {:ok, _lv, html} = live(conn, ~p"/users/confirm/#{token}")

      assert html =~ "Confirm your email"
      assert html =~ user.email
      assert html =~ "Confirm email"
    end

    test "confirms the account without logging the user in", %{conn: conn} do
      user = unconfirmed_user_fixture()
      token = generate_user_confirmation_token(user)

      {:ok, lv, _html} = live(conn, ~p"/users/confirm/#{token}")
      form = form(lv, "#confirmation_form", %{"user" => %{"token" => token}})
      render_submit(form)

      conn = follow_trigger_action(form, conn)

      assert redirected_to(conn) == ~p"/users/log-in"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Email confirmed successfully"
      assert Accounts.get_user!(user.id).confirmed_at
      refute get_session(conn, :user_token)
    end

    test "rejects an invalid token", %{conn: conn} do
      assert {:error, {:live_redirect, %{to: path, flash: flash}}} =
               live(conn, ~p"/users/confirm/invalid-token")

      assert path == ~p"/users/log-in"
      assert flash["error"] =~ "confirmation link is invalid or has expired"
    end
  end
end

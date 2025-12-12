defmodule YearbookWeb.ForgotPassword.Index do
  @moduledoc """
    Forgot password
  """
  use YearbookWeb, :auth_view

  alias Yearbook.Accounts

  def mount(_params, _session, socket) do
    socket = assign(socket, page_title: "Forgot Password | Yearbook")
    {:ok, socket}
  end
end

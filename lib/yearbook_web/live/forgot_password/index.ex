defmodule YearbookWeb.ForgotPassword.Index do
  @moduledoc """
    Forgot password
  """
  use YearbookWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end

defmodule YearbookWeb.PageController do
  use YearbookWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

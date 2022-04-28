defmodule YearbookWeb.PageController do
  use YearbookWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

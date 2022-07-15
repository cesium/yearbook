defmodule YearbookWeb.PageController do
  use YearbookWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def contacts(conn, _params) do
    render(conn, "contacts.html")
  end

  def terms(conn, _params) do
    render(conn, "terms.html")
  end
end

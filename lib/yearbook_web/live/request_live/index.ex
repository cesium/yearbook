defmodule YearbookWeb.RequestLive.Index do
  @moduledoc """
  Request Page
  """
  use YearbookWeb, :landing_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Pedido | Yearbook")}
  end
end

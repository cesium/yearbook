defmodule YearbookWeb.LandingPage.Index do
  use YearbookWeb, :navbar

  @moduledoc """
    Landing Page
  """
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Home | Yearbook")}
  end
end

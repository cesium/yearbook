defmodule YearbookWeb.YearbookLive.Show do
  @moduledoc false
  use YearbookWeb, :live_view

  alias Yearbook.University
  alias Yearbook.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"class_id" => id}, _, socket) do
    class = University.get_class!(id, [:students, :degree, :academic_year])

    {:noreply,
     socket
     |> assign(:page_title, class.degree.name)
     |> assign(:class, class)}
  end
end

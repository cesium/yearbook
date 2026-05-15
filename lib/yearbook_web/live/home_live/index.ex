defmodule YearbookWeb.HomeLive.Index do
  @moduledoc """
    Landing Page
  """
  use YearbookWeb, :landing_view
  alias Yearbook.Entries
  import YearbookWeb.Components.EntryCard
  import YearbookWeb.Components.Pagination

  @page_size 10

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Home | Yearbook")
     |> assign(filters: %{"masters" => "", "year" => ""})
     |> assign(page_size: @page_size)}
  end

  def handle_params(params, _url, socket) do
    page = params["page"] || "1"
    new_filters = Map.take(params, ["masters", "year"])
    current_filters = Map.merge(socket.assigns.filters, new_filters)

    results =
      Entries.list_accepted_entries_pagination(Map.merge(current_filters, %{"page" => page}))

    socket =
      socket
      |> assign(entries: results.entries)
      |> assign(filters: current_filters)
      |> assign(params: params)
      |> assign(current_page_num: results.current_page)
      |> assign(total_pages: results.total_pages)
      |> assign(total_count: results.total_count)

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Pedido | Yearbook")
    |> assign(:entry, %Entries.Entry{})
  end

  defp apply_action(socket, _action, _params) do
    socket
  end

  def handle_event("filter_changed", params, socket) do
    new_params = Map.put(params, "page", 1)
    {:noreply, push_patch(socket, to: ~p"/?#{new_params}")}
  end

  defp list_academic_years do
    current_year = Date.utc_today().year

    years =
      2020..current_year
      |> Enum.map(fn y -> {format_academic_year(y), "#{y}"} end)
      |> Enum.reverse()

    [{"Todos os Anos", ""} | years]
  end

  defp format_academic_year(year) do
    "#{year - 1}/#{rem(year, 100)}"
  end
end

defmodule YearbookWeb.HomeLive.Index do
  @moduledoc """
    Landing Page
  """
  use YearbookWeb, :landing_view
  alias Yearbook.Entries
  import YearbookWeb.Components.EntryCard

  def mount(_params, _session, socket) do
    entries = Entries.list_accepted_entries(%{"masters" => "", "year" => ""})

    {:ok,
     socket
     |> assign(page_title: "Home | Yearbook")
     |> assign(entries: entries)
     |> assign(total_entries: Enum.count(entries))
     |> assign(filters: %{"masters" => "", "year" => ""})}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("filter_changed", params, socket) do
    entries = Entries.list_accepted_entries(params)

    {:noreply,
     socket
     |> assign(entries: entries)
     |> assign(total_entries: Enum.count(entries))
     |> assign(filters: params)}
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

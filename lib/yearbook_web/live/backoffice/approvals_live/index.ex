defmodule YearbookWeb.Approvals do
  @moduledoc """
  Approvals page
  """
  use YearbookWeb, :live_view
  alias Yearbook.Entries

  def mount(_params, _session, socket) do
    {:ok, assign(socket, selected_entry: nil, confirmation: nil)}
  end

  def handle_params(params, _url, socket) do
    data = Entries.list_pending_entries_pagination(params)

    {:noreply,
     socket
     |> assign(entries: data.entries)
     |> assign(current_page_num: data.current_page)
     |> assign(total_pages: data.total_pages)
     |> assign(params: params)
     |> assign(current_page: :request_approvals)}
  end

  def handle_event("show_details", %{"id" => id}, socket) do
    entry = Entries.get_entry!(id)
    {:noreply, assign(socket, selected_entry: entry)}
  end

  def handle_event("confirm_action", %{"id" => id, "action" => action}, socket) do
    entry = Entries.get_entry!(id)
    {:noreply, assign(socket, confirmation: %{entry: entry, action: action})}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, selected_entry: nil, confirmation: nil)}
  end

  def handle_event("approve", %{"id" => id}, socket) do
    execute_update(socket, id, :accepted, "Entry approved successfully.")
  end

  def handle_event("deny", %{"id" => id}, socket) do
    execute_update(socket, id, :denied, "Entry denied successfully.")
  end

  def execute_update(socket, id, status, success_msg) do
    entry = Entries.get_entry!(id)

    case Entries.update_entry(entry, %{status: status}) do
      {:ok, _} ->
        data = Entries.list_pending_entries_pagination(socket.assigns.params)

        {:noreply,
         socket
         |> put_flash(:info, success_msg)
         |> assign(confirmation: nil)
         |> assign_pagination_data(data)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Erro ao processar pedido.")}
    end
  end

  def assign_pagination_data(socket, data) do
    assign(socket,
      entries: data.entries,
      current_page_num: data.current_page,
      total_pages: data.total_pages
    )
  end

  def page_range(current, total) do
    if total <= 7 do
      Enum.to_list(1..total)
    else
      ([1, total] ++ Enum.to_list((current - 2)..(current + 2)))
      |> Enum.filter(&(&1 >= 1 and &1 <= total))
      |> Enum.uniq()
      |> Enum.sort()
      |> add_dots([])
    end
  end

  def add_dots([a, b | tail], acc) when b > a + 1 do
    add_dots([b | tail], acc ++ [a, :ellipsis])
  end

  def add_dots([head | tail], acc) do
    add_dots(tail, acc ++ [head])
  end

  def add_dots([], acc), do: acc
end

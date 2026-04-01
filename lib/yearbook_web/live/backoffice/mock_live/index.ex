defmodule YearbookWeb.Approvals do
  @moduledoc """
  Approvals page
  """
  use YearbookWeb, :live_view
  alias Yearbook.Entries

  def mount(_params, _session, socket) do
    {:ok, assign(socket, selected_entry: nil)}
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

  def handle_event("approve", %{"id" => id}, socket) do
    entry = Entries.get_entry!(id)

    case Entries.update_entry(entry, %{status: :accepted}) do
      {:ok, _} ->
        data = Entries.list_pending_entries_pagination(socket.assigns.params)

        {:noreply,
         socket
         |> put_flash(:info, "Entry approved successfully.")
         |> assign_pagination_data(data)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Error approving entry.")}
    end
  end

  def handle_event("deny", %{"id" => id}, socket) do
    entry = Entries.get_entry!(id)

    case Entries.update_entry(entry, %{status: :denied}) do
      {:ok, _} ->
        data = Entries.list_pending_entries_pagination(socket.assigns.params)

        {:noreply,
         socket
         |> put_flash(:info, "Entry denied successfully.")
         |> assign_pagination_data(data)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Error denying entry.")}
    end
  end

  def handle_event("show_details", %{"id" => id}, socket) do
    entry = Entries.get_entry!(id)
    {:noreply, assign(socket, selected_entry: entry)}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, selected_entry: nil)}
  end

  defp assign_pagination_data(socket, data) do
    assign(socket,
      entries: data.entries,
      current_page_num: data.current_page,
      total_pages: data.total_pages
    )
  end

  def render(assigns) do
    ~H"""
    <div class="flex-1 p-7 bg-white rounded-2xl">
      <h2 class="text-xl font-semibold mb-6 text-gray-700">Request Approvals</h2>

      <div class="space-y-1">
        <%= for entry <- @entries do %>
          <div class="flex items-center border-2 border-gray-500 rounded-md p-4 mb-2">
            <div class="flex items-center gap-12 flex-1 min-w-0">
              <span class="text-gray-900 w-64 shrink-0 font-medium">{entry.name}</span>
              <span class="text-gray-900 truncate pr-4 max-w-4xl">{entry.text}</span>
            </div>

            <div class="ml-auto flex flex-row items-center gap-8">
              <button
                phx-click="show_details"
                phx-value-id={entry.id}
                class="border-2 border-gray-500 px-2 py-1 rounded text-sm bg-gray-100 cursor-pointer"
              >
                Ver Detalhes
              </button>
              <div class="flex items-center gap-2">
                <button
                  phx-click="approve"
                  phx-value-id={entry.id}
                  class="text-green-400 hover:text-green-600 cursor-pointer"
                >
                  <.icon name="hero-check" class="size-8" />
                </button>
                <button
                  phx-click="deny"
                  phx-value-id={entry.id}
                  class="text-red-400 hover:text-red-600 cursor-pointer"
                >
                  <.icon name="hero-x-mark" class="size-8" />
                </button>
              </div>
            </div>
          </div>
        <% end %>
      </div>

      <div class="mt-6 flex items-center justify-between border-t border-gray-500 pt-4">
        <span class="text-sm text-gray-500">
          Página <strong>{@current_page_num}</strong> de {@total_pages}
        </span>

        <div class="flex gap-2">
          <.link
            :if={@current_page_num > 1}
            patch={~p"/backoffice/approvals?page=#{@current_page_num - 1}"}
            class=" hover:bg-gray-50 text-sm font-medium"
          >
            <.icon name="hero-chevron-left" class="size-5" />
          </.link>

          <.link
            :if={@current_page_num < @total_pages}
            patch={~p"/backoffice/approvals?page=#{@current_page_num + 1}"}
            class=" hover:bg-gray-50 text-sm font-medium"
          >
            <.icon name="hero-chevron-right" class="size-5" />
          </.link>
        </div>
      </div>
    </div>

    <%= if @selected_entry do %>
      <div class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div class="bg-white rounded-xl max-w-md w-full shadow-2xl overflow-hidden">
          <div style="background-color: black" class="p-6 flex justify-between items-center">
            <h3 class="text-white text-xl font-bold items-center">Detalhes do Pedido</h3>
            <button phx-click="close_modal" class="text-white/80 hover:text-white">
              <.icon name="hero-x-mark" class="size-8" />
            </button>
          </div>

          <div class="p-8">
            <div class="flex flex-col items-center mb-6">
              <img
                src={@selected_entry.photo}
                alt={@selected_entry.name}
                class="w-48 h-48 rounded-xl object-cover shrink-0 border border-gray-300"
              />
            </div>
            <div class="mb-6">
              <label class="text-xs font-bold uppercase text-gray-500 tracking-wider">Autor</label>
              <p class="text-lg text-gray-800 font-medium">{@selected_entry.name}</p>
            </div>

            <div class="mb-6">
              <label class="text-xs font-bold uppercase text-gray-500 tracking-wider">
                Frase
              </label>
              <p class="text-gray-800 font-semibold mt-1">
                "{@selected_entry.text}"
              </p>
            </div>
          </div>
        </div>
      </div>
    <% end %>
    """
  end
end

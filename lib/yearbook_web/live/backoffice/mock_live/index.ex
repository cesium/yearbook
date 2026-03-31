defmodule YearbookWeb.Approvals do
  use YearbookWeb, :live_view
  alias Yearbook.Entries

  def mount(_params, _session, socket) do
    entries = Entries.list_pending_entries()

    {:ok,
     socket
     |> assign(current_page: :request_approvals)
     |> assign(entries: entries)
     |> assign(selected_entry: nil)}
  end

  def handle_event("approve", %{"id" => id}, socket) do
    entry = Yearbook.Entries.get_entry!(id)

    case Yearbook.Entries.update_entry(entry, %{status: :accepted}) do
      {:ok, _updated_entry} ->
        new_entries = Yearbook.Entries.list_pending_entries()

        {:noreply, assign(socket, entries: new_entries)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Error approving entry.")}
    end
  end

  def handle_event("deny", %{"id" => id}, socket) do
    entry = Yearbook.Entries.get_entry!(id)

    case Yearbook.Entries.update_entry(entry, %{status: :denied}) do
      {:ok, _updated_entry} ->
        new_entries = Yearbook.Entries.list_pending_entries()
        {:noreply, assign(socket, entries: new_entries)}

      {:error, _changeset} ->
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

  def render(assigns) do
    ~H"""
    <div class="flex-1 p-8 bg-white rounded-2xl">
      <h2 class="text-xl font-semibold mb-6 text-gray-700">Request Approvals</h2>

      <div class="space-y-1">
        <%= for entry <- @entries do %>
          <div class="flex items-center border-2 border-gray-500 rounded-md p-4 ">
            <div class="flex items-center gap-12 flex-1 min-w-0">
              <span class=" text-gray-900 w-64 shrink-0">{entry.name}</span>
              <span class="text-gray-900 truncate pr-4 max-w-4xl">{entry.text}</span>
            </div>

            <div class="ml-auto flex flex-row items-center gap-8">
              <button
                phx-click="show_details"
                phx-value-id={entry.id}
                class="border-2 border-gray-500 px-2 py-1 rounded text-sm bg-gray-100"
              >
                Ver Detalhes
              </button>
              <div class="flex items-center gap-2">
                <button
                  phx-click="approve"
                  phx-value-id={entry.id}
                  class="text-green-400 hover:text-green-600"
                >
                  <.icon name="hero-check" class="size-8" />
                </button>

                <button
                  phx-click="deny"
                  phx-value-id={entry.id}
                  class="text-red-400 hover:text-red-600"
                >
                  <.icon name="hero-x-mark" class="size-8" />
                </button>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>

    <%= if @selected_entry do %>
      <div
        class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4"
      >
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
                Quote
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

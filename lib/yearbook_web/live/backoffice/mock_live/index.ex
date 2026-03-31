defmodule YearbookWeb.Approvals do
  use YearbookWeb, :live_view
  alias Yearbook.Entries

  def mount(_params, _session, socket) do
    entries = Entries.list_pending_entries()

    {:ok,
     socket
     |> assign(current_page: :request_approvals)
     |> assign(entries: entries)}
  end

  def handle_event("approve", %{"id" => id}, socket) do
    entry = Yearbook.Entries.get_entry!(id)

    case Yearbook.Entries.update_entry(entry, %{status: :accepted}) do
      {:ok, _updated_entry} ->
        new_entries = Yearbook.Entries.list_pending_entries()

        {:noreply, assign(socket, entries: new_entries)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Erro ao aprovar.")}
    end
  end

  def handle_event("deny", %{"id" => id}, socket) do
    entry = Yearbook.Entries.get_entry!(id)

    case Yearbook.Entries.update_entry(entry, %{status: :denied}) do
      {:ok, _updated_entry} ->
        new_entries = Yearbook.Entries.list_entries()
        {:noreply, assign(socket, entries: new_entries)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Erro ao rejeitar.")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="flex-1 p-8 bg-white rounded-2xl">
      <h2 class="text-xl font-semibold mb-6 text-gray-700">Request Approvals</h2>

      <div class="space-y-2">
        <%= for entry <- @entries do %>
          <div class="flex items-center border-2 border-gray-600 rounded-xl p-4 ">
            <div class="flex items-center gap-12 flex-1 min-w-0">
              <span class=" text-gray-900 w-64 shrink-0">{entry.name}</span>
              <span class="text-gray-900 truncate pr-4 max-w-4xl">{entry.text}</span>
            </div>

            <div class="ml-auto flex flex-row items-center gap-8">
              <button class="border-2 border-gray-700 px-2 py-1 rounded text-sm">Ver Detalhes</button>
              <div class="flex items-center gap-2">
                <button phx-click="approve" phx-value-id={entry.id} class="text-green-400 hover:text-green-600">
                  <.icon name="hero-check" class="size-8" />
                </button>

                <button phx-click="deny" phx-value-id={entry.id} class="text-red-400 hover:text-red-600">
                  <.icon name="hero-x-mark" class="size-8" />
                </button>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end

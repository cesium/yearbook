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

  defp page_range(current, total) do
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

  defp add_dots([a, b | tail], acc) when b > a + 1 do
    add_dots([b | tail], acc ++ [a, :ellipsis])
  end

  defp add_dots([head | tail], acc) do
    add_dots(tail, acc ++ [head])
  end

  defp add_dots([], acc), do: acc

  def render(assigns) do
    ~H"""
    <div class="flex-1 p-10 bg-white rounded-2xl shadow-sm border border-gray-100">
      <div class="mb-10">
        <h2 class="text-2xl font-bold text-gray-800 tracking-tight">Aprovações Pendentes</h2>
      </div>

      <div class="flex items-center px-4 pb-4 text-[11px] font-bold uppercase tracking-widest text-gray-400 border-b border-gray-100">
        <div class="w-1/4">Autor</div>
        <div class="hidden md:block flex-1">Frase</div>
        <div class="w-32"></div>
      </div>

      <div class="divide-y divide-gray-100">
        <%= for entry <- @entries do %>
          <div class="group flex items-center px-4 py-5 hover:bg-gray-50/50 transition-colors duration-150">
            <div class="w-1/4 min-w-0 pr-4">
              <span class="text-sm font-semibold text-gray-700 truncate block">
                {entry.name}
              </span>
            </div>

            <div class="hidden md:block flex-1 min-w-0 pr-4">
              <span class="text-sm text-gray-500 line-clamp-1 block">
                {entry.text}
              </span>
            </div>

            <div class="flex-1 md:flex-none md:w-32 flex justify-end items-center gap-4">
              <button
                phx-click="show_details"
                phx-value-id={entry.id}
                class="text-gray-600 hover:text-gray-400 transition-colors cursor-pointer"
              >
                <.icon name="hero-eye" class="size-5" />
              </button>

              <button
                phx-click="approve"
                phx-value-id={entry.id}
                class="text-gray-600 hover:text-gray-400 transition-colors cursor-pointer"
              >
                <.icon name="hero-check" class="size-6" />
              </button>

              <button
                phx-click="deny"
                phx-value-id={entry.id}
                class="text-gray-600 hover:text-gray-400 transition-colors cursor-pointer"
              >
                <.icon name="hero-trash" class="size-5" />
              </button>
            </div>
          </div>
        <% end %>
      </div>

      <div class="mt-7 flex items-center justify-between border-t border-gray-100 pt-3">
        <span class="text-xs font-medium text-gray-400 uppercase tracking-wider">
          Página <strong class="text-gray-700">{@current_page_num}</strong> de {@total_pages}
        </span>

        <div class="flex items-center gap-1">
          <.link
            :if={@current_page_num > 1}
            patch={~p"/backoffice/approvals?page=#{@current_page_num - 1}"}
            class="p-2 text-gray-400 hover:text-gray-700 transition-all"
          >
            <.icon name="hero-chevron-left" class="size-5" />
          </.link>

          <%= for item <- page_range(@current_page_num, @total_pages) do %>
            <%= if item == :ellipsis do %>
              <span class="px-2 text-gray-400">...</span>
            <% else %>
              <.link
                patch={~p"/backoffice/approvals?page=#{item}"}
                class={[
                  "w-8 h-8 flex items-center justify-center rounded-lg text-xs font-bold transition-all",
                  if(item == @current_page_num,
                    do: "bg-gray-800 text-white shadow-sm",
                    else: "text-gray-400 hover:bg-gray-100 hover:text-gray-700"
                  )
                ]}
              >
                {item}
              </.link>
            <% end %>
          <% end %>

          <.link
            :if={@current_page_num < @total_pages}
            patch={~p"/backoffice/approvals?page=#{@current_page_num + 1}"}
            class="p-2 text-gray-400 hover:text-gray-700 transition-all"
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
            <button phx-click="close_modal" class="text-white/80 hover:text-white cursor-pointer">
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

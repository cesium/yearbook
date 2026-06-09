defmodule YearbookWeb.EntryFormComponent do
  @moduledoc """
  Entry form component.
  """
  use YearbookWeb, :live_component
  alias Yearbook.Entries
  import YearbookWeb.Components.PhotoUploadCard

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full flex justify-center">
      <div class="w-full max-w-2xl">
        <header class="mb-10">
          <h2 class="text-3xl font-bold text-gray-900 tracking-tight">
            Novo Pedido
          </h2>
          <p class="text-sm text-gray-500 mt-2">
            Preenche os dados para apareceres no Yearbook.
          </p>
        </header>

        <.form
          for={@form}
          id="entry-form"
          as={:entry}
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
          class="space-y-6"
        >
          <.input field={@form[:year]} type="hidden" value={@current_year} />

          <div class="flex flex-col md:flex-row gap-12 items-start">
            <div class="grow w-full space-y-6 mt-2">
              <div>
                <label class="block text-xs font-semibold text-gray-600 mb-2">Nome</label>
                <.input
                  field={@form[:name]}
                  type="text"
                  placeholder="Ex: Angela Martin"
                  class="w-full px-5 py-4 rounded-2xl bg-white border border-gray-300 focus:bg-white focus:border-orange-500 focus:ring-4 focus:ring-orange-500/10 transition-all outline-none text-sm"
                />
              </div>

              <div>
                <label class="block text-xs font-semibold text-gray-600 mb-2">Frase</label>
                <.input
                  field={@form[:text]}
                  type="textarea"
                  maxlength="200"
                  rows="7"
                  placeholder="Max 200 caracteres"
                  class="w-full px-5 py-4 rounded-2xl bg-white border border-gray-300 focus:bg-white focus:border-orange-500 focus:ring-4 focus:ring-orange-500/10 transition-all outline-none text-sm resize-none"
                />
              </div>
            </div>

            <div class="shrink-0 w-full md:w-64 flex justify-center md:pt-8">
              <.photo_upload_card
                upload={@uploads.photo}
                staged_photo_path={@staged_photo_path}
                show_upload_button={false}
              />
            </div>
          </div>

          <label class="group flex items-center gap-3 px-2 py-4 rounded-2xl bg-orange-50 border border-orange-100 cursor-pointer">
            <.input
              field={@form[:masters]}
              type="checkbox"
              class="hidden"
            />

            <div class="flex justify-center items-center w-5 h-5 rounded border border-gray-300 bg-white group-has-checked:bg-orange-200 group-has-checked:border-orange-300">
              <.icon
                name="hero-check"
                class="size-4 text-gray-900 hidden group-has-checked:block"
              />
            </div>

            <span class="text-sm font-medium text-gray-700 mt-1">
              Acabei o Mestrado
            </span>
          </label>

          <div class="pt-4">
            <button
              type="submit"
              phx-disable-with="A enviar..."
              disabled={upload_in_progress?(@uploads.photo, @staged_photo_path)}
              class="w-full py-4 rounded-2xl bg-black text-white text-xs font-bold tracking-widest uppercase hover:bg-gray-900 hover:shadow-lg transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <%= if upload_in_progress?(@uploads.photo, @staged_photo_path) do %>
                A carregar foto...
              <% else %>
                Enviar Pedido
              <% end %>
            </button>
          </div>
        </.form>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:staged_photo_path, nil)
     |> allow_upload(:photo,
       accept: ~w(.jpg .jpeg .png),
       auto_upload: true,
       progress: &handle_progress/3,
       max_entries: 1,
       max_file_size: 5_000_000
     )}
  end

  @impl true
  def update(%{entry: entry} = assigns, socket) do
    current_year = Date.utc_today().year
    changeset = Entries.change_entry(entry, %{"year" => current_year})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:current_year, current_year)
     |> assign(:staged_photo_path, Map.get(assigns, :staged_photo_path))
     |> assign_form(changeset)}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("validate", %{"entry" => entry_params}, socket) do
    changeset =
      socket.assigns.entry
      |> Entries.change_entry(entry_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"entry" => entry_params}, socket) do
    entry_params =
      entry_params
      |> Map.put("photo", socket.assigns.staged_photo_path)
      |> Map.put_new("year", socket.assigns.current_year)

    case Entries.create_entry(entry_params) do
      {:ok, _entry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Entrada criada com sucesso!")
         |> redirect(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp handle_progress(:photo, entry, socket) do
    if entry.done? do
      file_path =
        consume_uploaded_entry(socket, entry, fn %{path: path} ->
          {:ok, YearbookWeb.Components.PhotoUploadCard.store_photo(path, entry)}
        end)

      {:noreply, assign(socket, :staged_photo_path, file_path)}
    else
      {:noreply, socket}
    end
  end

  defp upload_in_progress?(upload, staged_photo_path) do
    staged_photo_path == nil and upload.entries != []
  end
end

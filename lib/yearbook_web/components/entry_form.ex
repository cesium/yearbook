defmodule YearbookWeb.EntryFormComponent do
  @moduledoc """
  Entry form component.
  """
  use YearbookWeb, :live_component
  alias Yearbook.Entries
  alias YearbookWeb.Components.PhotoUploadCard
  import YearbookWeb.Components.PhotoUploadCard
  import YearbookWeb.Components.AcademicYear

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full max-w-screen-2xl">
      <header class="mb-8">
        <h2 class="text-xl font-medium font-orbitron text-primary tracking-tight">
          {gettext("Realiza aqui o teu pedido")}
        </h2>
        <p class="text-sm text-gray-500 mt-2">
          {gettext("Preenche os dados para apareceres no Yearbook.")}
        </p>
      </header>

      <.form
        for={@form}
        id="entry-form"
        as={:entry}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
          <div class="flex flex-col md:flex-row gap-6 md:gap-8 items-start">
            <div class="w-full md:w-64 md:shrink-0">
            <.photo_upload_card
              upload={@uploads.photo}
              staged_photo_path={@staged_photo_path}
              show_upload_button={false}
            />
          </div>
            <div class="w-full min-w-0 flex-1 flex flex-col gap-5">
            <div>
              <label class="block text-xs font-inter font-medium text-primary mb-2">
                {gettext("Ano Letivo")}
              </label>
              <.academic_year
                year={@academic_year}
                masters=""
                target={@myself}
                include_all={false}
                include_title={false}
              />
            </div>

            <div>
              <label class="block text-xs font-inter font-medium text-primary mb-2">
                {gettext("Sou finalista de")}
              </label>
              <div class="flex flex-wrap gap-x-5 gap-y-2">
                <label class="flex items-center gap-2 text-sm font-medium text-primary cursor-pointer">
                  <input
                    type="radio"
                    name={@form[:masters].name}
                    value="false"
                    checked={@form[:masters].value in [nil, false, "false"]}
                  /> {gettext("Licenciatura")}
                </label>

                <label class="flex items-center gap-2 text-sm font-medium text-primary cursor-pointer">
                  <input
                    type="radio"
                    name={@form[:masters].name}
                    value="true"
                    checked={@form[:masters].value in [true, "true"]}
                  /> {gettext("Mestrado")}
                </label>
              </div>
            </div>

            <div class="space-y-5 min-w-0">
              <div>
                <label class="block text-xs font-inter font-medium text-primary mb-2">
                  {gettext("Nome")}
                </label>
                <.input
                  field={@form[:name]}
                  type="text"
                  placeholder="Ex: Angela Martin"
                  class="w-full px-5 py-2 rounded-xl bg-white border border-gray-300 focus:bg-white focus:text-primary focus:outline-none focus:ring-1 focus:ring-main transition-all text-sm"
                />
              </div>

              <div>
                <label class="block text-xs font-inter font-medium text-primary mb-2">
                  {gettext("Frase")}
                </label>
                <.input
                  field={@form[:text]}
                  type="textarea"
                  maxlength="200"
                  rows="7"
                  placeholder="Máx. 200 caracteres"
                  class="w-full px-5 py-4 rounded-xl bg-white border border-gray-300 focus:bg-white focus:text-primary focus:outline-none focus:ring-1 focus:ring-main transition-all text-sm resize-none"
                />
              </div>
            </div>

            <div class="pt-1">
              <button
                type="submit"
                phx-disable-with="A enviar..."
                disabled={upload_in_progress?(@uploads.photo, @staged_photo_path)}
                class="w-fit px-4 py-2 rounded-xl bg-main text-white text-xs font-bold tracking-widest uppercase hover:bg-gray-900 hover:shadow-lg transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <%= if upload_in_progress?(@uploads.photo, @staged_photo_path) do %>
                  {gettext("A carregar foto...")}
                <% else %>
                  {gettext("Enviar Pedido")}
                <% end %>
              </button>
            </div>
          </div>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:academic_year, "")
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
    academic_year = Map.get(assigns, :academic_year, socket.assigns.academic_year)
    changeset = Entries.change_entry(entry, %{"year" => academic_year})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:academic_year, academic_year)
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
      |> Map.put("year", socket.assigns.academic_year)

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

  def handle_event("filter_changed", %{"year" => year}, socket) do
    changeset = Entries.change_entry(socket.assigns.entry, %{"year" => year})

    {:noreply,
     socket
     |> assign(:academic_year, year)
     |> assign_form(changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp handle_progress(:photo, entry, socket) do
    if entry.done? do
      file_path =
        consume_uploaded_entry(socket, entry, fn %{path: path} ->
          {:ok, PhotoUploadCard.store_photo(path, entry)}
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

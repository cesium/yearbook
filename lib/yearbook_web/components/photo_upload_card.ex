defmodule YearbookWeb.Components.PhotoUploadCard do
  @moduledoc """
  Photo upload card component.
  """

  use YearbookWeb, :live_component

  import YearbookWeb.Components.PhotoUploader

  attr :upload, :any, required: true
  attr :staged_photo_path, :string, default: nil
  attr :show_upload_button, :boolean, default: true
  attr :upload_error, :string, default: nil
  attr :phx_target, :any, default: nil

  def photo_upload_card(assigns) do
    ~H"""
    <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-200 w-full max-w-md mx-auto">
      <%= if @staged_photo_path do %>
        <div class="flex flex-col gap-6 text-center">
          <img
            src={@staged_photo_path}
            class="w-48 h-48 object-cover rounded-xl mx-auto border-2 border-primary"
          />
          <p class="text-sm font-bold text-primary">Foto carregada com sucesso!</p>
        </div>
      <% else %>
        <div class="flex flex-col gap-4">
          <%= if @upload_error do %>
            <p class="text-xs text-red-500 text-center font-bold tracking-wider">
              {@upload_error}
            </p>
          <% end %>

          <.photo_uploader
            phx_target={@phx_target}
            phx_change="validate"
            phx_drop_target={@upload.ref}
            class="h-48 w-48 mx-auto rounded-xl border-primary/30! hover:border-primary! hover:bg-primary/5! transition-all! overflow-hidden cursor-pointer"
            upload={@upload}
            image_class="w-full h-full object-cover"
          >
            <:placeholder>
              <div class="flex flex-col gap-2 items-center justify-center h-full text-primary/50 hover:text-primary transition-colors p-4">
                <.icon name="hero-arrow-up-tray" class="w-8 h-8" />
                <p class="text-sm font-medium text-gray-600">Escolha uma foto</p>
                <p class="text-[10px] text-gray-400 uppercase tracking-widest mt-1">
                  PNG · JPG · JPEG · max 5 MB
                </p>
              </div>
            </:placeholder>
          </.photo_uploader>

          <%= for err <- upload_errors(@upload) do %>
            <p class="text-xs text-red-500 text-center font-bold tracking-wider">
              {error_to_string(err)}
            </p>
          <% end %>
          <%= for entry <- @upload.entries, err <- upload_errors(@upload, entry) do %>
            <p class="text-xs text-red-500 text-center font-bold tracking-wider">
              {error_to_string(err)}
            </p>
          <% end %>

          <%= if @show_upload_button do %>
            <button
              type="submit"
              class="w-full py-3.5 rounded-full bg-primary text-white font-bold tracking-widest text-xs hover:bg-primary/85 active:scale-[0.98] transition-all duration-200 disabled:opacity-40 disabled:cursor-not-allowed"
              disabled={@upload.entries == [] or upload_errors(@upload) != []}
              phx-disable-with="A CARREGAR..."
            >
              UPLOAD
            </button>
          <% else %>
            <%= for entry <- @upload.entries, upload_errors(@upload, entry) == [] do %>
              <div class="space-y-2">
                <div class="h-2 rounded-full bg-gray-100 overflow-hidden">
                  <div
                    class="h-full rounded-full bg-primary transition-all duration-300"
                    style={"width: #{entry.progress}%"}
                  />
                </div>
                <p class="text-[10px] text-center font-bold text-primary tracking-widest">
                  A CARREGAR {entry.progress}%
                </p>
              </div>
            <% end %>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <form
      id={"#{@id}-form"}
      phx-target={@myself}
      phx-change="validate"
      phx-submit="save"
      class="contents"
    >
      <.photo_upload_card
        upload={@uploads.photo}
        staged_photo_path={@staged_photo_path}
        show_upload_button={@show_upload_button}
        upload_error={@upload_error}
        phx_target={@myself}
      />
    </form>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:staged_photo_path, nil)
     |> assign(:upload_error, nil)
     |> allow_upload(:photo,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1,
       max_file_size: 5_000_000
     )}
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:show_upload_button, fn -> true end)
     |> assign_new(:staged_photo_path, fn -> nil end)
     |> assign_new(:upload_error, fn -> nil end)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("reset_upload", _params, socket) do
    {:noreply, assign(socket, :staged_photo_path, nil)}
  end

  @impl true
  def handle_event("save", %{}, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :photo, fn %{path: path}, entry ->
        {:ok, store_photo(path, entry)}
      end)

    case uploaded_files do
      [file_path] ->
        send(self(), {:photo_uploaded, socket.assigns.id, file_path})

        {:noreply,
         socket
         |> assign(:staged_photo_path, file_path)
         |> assign(:upload_error, nil)}

      [] ->
        {:noreply, assign(socket, :upload_error, "Ocorreu um erro ao processar a foto!")}
    end
  rescue
    _exception ->
      {:noreply, assign(socket, :upload_error, "Ocorreu um erro ao processar a foto!")}
  end

  def store_photo(path, entry) do
    filename = "#{Ecto.UUID.generate()}-#{entry.client_name}"
    upload_dir = Path.expand("priv/uploads")
    File.mkdir_p!(upload_dir)
    dest = Path.join(upload_dir, filename)
    File.cp!(path, dest)
    "/uploads/#{filename}"
  end

  defp error_to_string(:too_large), do: "Foto demasiado grande (máx 5MB)!"
  defp error_to_string(:not_accepted), do: "Formato inválido!"
  defp error_to_string(:too_many_files), do: "Apenas uma foto permitida!"
  defp error_to_string(_), do: "Erro desconhecido!"
end

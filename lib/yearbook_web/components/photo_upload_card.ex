defmodule YearbookWeb.Components.PhotoUploadCard do
  @moduledoc """
  Photo upload card component.
  """

  use YearbookWeb, :live_component

  import YearbookWeb.Components.PhotoUploader

  @impl true
  def render(assigns) do
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
        <form
          id="photo-upload-form"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
          class="flex flex-col gap-4"
        >
          <.photo_uploader
            class="h-48 w-48 mx-auto rounded-xl border-primary/30! hover:border-primary! hover:bg-primary/5! transition-all! overflow-hidden cursor-pointer"
            upload={@uploads.photo}
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

          <%= for err <- upload_errors(@uploads.photo) do %>
            <p class="text-xs text-red-500 text-center font-bold tracking-wider">
              {error_to_string(err)}
            </p>
          <% end %>
          <%= for entry <- @uploads.photo.entries, err <- upload_errors(@uploads.photo, entry) do %>
            <p class="text-xs text-red-500 text-center font-bold tracking-wider">
              {error_to_string(err)}
            </p>
          <% end %>

          <button
            type="submit"
            class="w-full py-3.5 rounded-full bg-primary text-white font-bold tracking-widest text-xs hover:bg-primary/85 active:scale-[0.98] transition-all duration-200 disabled:opacity-40 disabled:cursor-not-allowed"
            disabled={@uploads.photo.entries == [] or upload_errors(@uploads.photo) != []}
            phx-disable-with="A CARREGAR..."
          >
            UPLOAD
          </button>
        </form>
      <% end %>
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
       max_entries: 1,
       max_file_size: 5_000_000
     )}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{}, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :photo, fn %{path: path}, entry ->
        filename = "#{Ecto.UUID.generate()}-#{entry.client_name}"
        upload_dir = Path.join([:code.priv_dir(:yearbook), "uploads"])
        File.mkdir_p!(upload_dir)
        dest = Path.join(upload_dir, filename)
        File.cp!(path, dest)
        {:ok, "/uploads/#{filename}"}
      end)

    case uploaded_files do
      [file_path] ->
        send(self(), {:photo_staged, file_path})

        {:noreply, assign(socket, :staged_photo_path, file_path)}

      [] ->
        {:noreply, put_flash(socket, :error, "Ocorreu um erro ao processar a foto!")}
    end
  end

  defp error_to_string(:too_large), do: "Foto demasiado grande (máx 5MB)!"
  defp error_to_string(:not_accepted), do: "Formato inválido!"
  defp error_to_string(:too_many_files), do: "Apenas uma foto permitida!"
  defp error_to_string(_), do: "Erro desconhecido!"
end

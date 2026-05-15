defmodule YearbookWeb.Components.PhotoUploadCard do
  @moduledoc """
  Photo upload card component.
  """

  use YearbookWeb, :component

  import YearbookWeb.Components.PhotoUploader

  attr :upload, :any, required: true
  attr :staged_photo_path, :string, default: nil

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
          <.photo_uploader
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
        </div>
      <% end %>
    </div>
    """
  end

  defp error_to_string(:too_large), do: "Foto demasiado grande (máx 5MB)!"
  defp error_to_string(:not_accepted), do: "Formato inválido!"
  defp error_to_string(:too_many_files), do: "Apenas uma foto permitida!"
  defp error_to_string(_), do: "Erro desconhecido!"
end

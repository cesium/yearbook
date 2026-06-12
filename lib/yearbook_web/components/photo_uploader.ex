defmodule YearbookWeb.Components.PhotoUploader do
  @moduledoc """
  Photo uploader component.
  """
  use YearbookWeb, :component

  attr :upload, :any, required: true
  attr :class, :string, default: ""
  attr :image_class, :string, default: ""
  attr :image, :string, default: nil
  attr :icon, :string, default: "hero-photo"
  attr :preview_disabled, :boolean, default: false
  attr :rounded, :boolean, default: false
  attr :capture, :string, default: nil
  attr :accept, :string, default: nil

  attr :phx_target, :any, default: nil
  attr :phx_change, :string, default: nil
  attr :phx_drop_target, :any, default: nil

  slot :placeholder, required: false, doc: "Slot for the placeholder content."

  def photo_uploader(assigns) do
    ~H"""
    <.live_file_input
      upload={@upload}
      class="sr-only"
      capture={@capture}
      accept={@accept}
      phx-change={@phx_change}
      phx-target={@phx_target}
    />
    <label for={@upload.ref} class="block">
      <section
        phx-drop-target={@phx_drop_target || @upload.ref}
        class={[
          "transition-colors hover:cursor-pointer border-2 border-dashed",
          @rounded && "rounded-full overflow-hidden",
          @class
        ]}
      >
        <%= if @upload.entries == [] do %>
          <article class="h-full">
            <figure class="h-full flex items-center justify-center">
              <%= if @image do %>
                <img class={[@rounded && "p-0", not @rounded && "p-4", @image_class]} src={@image} />
              <% else %>
                <%= if @placeholder do %>
                  {render_slot(@placeholder)}
                <% else %>
                  <div class="select-none flex flex-col gap-2 items-center">
                    <.icon name={@icon} class="w-12 h-12" />
                    <p class="px-4 text-center">{gettext("Upload a file or drag and drop.")}</p>
                  </div>
                <% end %>
              <% end %>
            </figure>
          </article>
        <% end %>
        <%= if !@preview_disabled do %>
          <%= for entry <- @upload.entries do %>
            <article class="h-full">
              <figure class="h-full flex items-center justify-center">
                <%= if image_file?(entry) do %>
                  <.live_img_preview
                    class={[@rounded && "p-0", not @rounded && "p-4", @image_class]}
                    entry={entry}
                  />
                <% else %>
                  <div class="select-none flex flex-col gap-2 items-center">
                    <.icon name="hero-document" class="w-12 h-12" />
                    <p class="px-4 text-center">{entry.client_name}</p>
                  </div>
                <% end %>
              </figure>
              <%= for err <- upload_errors(@upload, entry) do %>
                <p class="alert alert-danger">{Phoenix.Naming.humanize(err)}</p>
              <% end %>
            </article>
          <% end %>
        <% end %>
        <%= for err <- upload_errors(@upload) do %>
          <p class="alert alert-danger">{Phoenix.Naming.humanize(err)}</p>
        <% end %>
      </section>
    </label>
    """
  end

  defp image_file?(entry) do
    entry.client_type in ["image/jpeg", "image/png", "image/gif", "image/heic", "image/webp"]
  end
end

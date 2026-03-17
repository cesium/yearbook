defmodule YearbookWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use YearbookWeb, :html

  import YearbookWeb.Navbar
  import YearbookWeb.Footer

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="h-screen w-full">
      <div class="bg-white flex items-center justify-between w-full h-20 px-4 border-b-3 border-primary">
        <div class="flex z-10 justify-between h-full items-center">
          <div class="p-3 rounded-2xl">
            <.link navigate={~p"/"} class="flex items-center gap-3 cursor-pointer">
              <span class="hero-academic-cap text-black h-8 w-8"></span>
              <span class="text-2xl font-bold text-black">YEARBOOK</span>
            </.link>
          </div>
        </div>
        <div class="flex items-center gap-3">
          <%= if @current_scope && @current_scope.user do %>
            <.link
              navigate={~p"/users/settings"}
              class="inline-flex items-center justify-center w-32 h-10 rounded-lg border border-primary text-primary font-medium hover:bg-primary/10 transition"
            >
              Settings
            </.link>
            <.link
              href={~p"/users/log-out"}
              method="delete"
              class="inline-flex items-center justify-center w-32 h-10 rounded-lg border border-primary text-primary font-medium hover:bg-primary/10 transition"
            >
              Logout
            </.link>
          <% else %>
            <.link
              navigate={~p"/users/register"}
              class="inline-flex items-center justify-center w-32 h-10 rounded-lg border border-primary text-primary font-medium hover:bg-primary/10 transition"
            >
              Sign Up
            </.link>
            <.link
              navigate={~p"/users/log-in"}
              class="inline-flex items-center justify-center w-32 h-10 rounded-lg border border-primary text-primary font-medium hover:bg-primary/10 transition"
            >
              Sign In
            </.link>
          <% end %>
        </div>
      </div>

      <div class="flex grow md:place-items-center">
        {render_slot(@inner_block)}
      </div>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border border-base-200 bg-base-100 brightness-200 left-0 in-data-[theme=light]:left-1/3 in-data-[theme=dark]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end

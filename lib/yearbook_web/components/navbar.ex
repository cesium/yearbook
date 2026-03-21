defmodule YearbookWeb.Navbar do
  @moduledoc """
  Navbar component.
  """

  use YearbookWeb, :html

  attr :current_scope, :any, default: nil

  def navbar(assigns) do
    ~H"""
    <div class="bg-white flex items-center justify-between w-full h-16 sm:h-20 px-3 sm:px-4 border-b-2 border-primary">
      <div class="flex z-10 justify-between h-full items-center">
        <div class="p-2 sm:p-3 rounded-2xl">
          <.link navigate={~p"/"} class="flex items-center gap-2 sm:gap-3 cursor-pointer">
            <span class="hero-academic-cap text-black h-7 w-7 sm:h-8 sm:w-8"></span>
            <span class="text-xl sm:text-2xl font-bold text-black">YEARBOOK</span>
          </.link>
        </div>
      </div>
      <div class="flex items-center gap-1 sm:gap-3">
        <%= if assigns[:current_scope] && assigns.current_scope.user do %>
          <.link
            navigate={~p"/users/settings"}
            class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-semibold hover:text-primary transition cursor-pointer"
          >
            Settings
          </.link>
          <.link
            href={~p"/users/log-out"}
            method="delete"
            class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-semibold hover:text-primary transition cursor-pointer"
          >
            Logout
          </.link>
        <% else %>
          <.link
            navigate={~p"/users/register"}
            class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-semibold hover:text-primary transition cursor-pointer"
          >
            Sign Up
          </.link>
          <.link
            navigate={~p"/users/log-in"}
            class="inline-flex items-center justify-center px-3 sm:w-32 h-9 sm:h-10 text-sm sm:text-base font-semibold hover:text-primary transition cursor-pointer"
          >
            Sign In
          </.link>
        <% end %>
      </div>
    </div>
    """
  end
end

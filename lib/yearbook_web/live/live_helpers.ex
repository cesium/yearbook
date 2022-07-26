defmodule YearbookWeb.LiveHelpers do
  @moduledoc """
  Utility functions for LiveViews and LiveComponents.
  """
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.admin_academic_year_index_path(@socket, :index)}>
        <.live_component
          module={YearbookWeb.AcademicYearLive.FormComponent}
          id={@academic_year.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.admin_academic_year_index_path(@socket, :index)}
          academic_year: @academic_year
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div id="modal-content" class="shadow overflow-hidden sm:rounded-md phx-modal-content fade-in-scale max-w-7xl" phx-click-away={JS.dispatch("click", to: "#close")} phx-window-keydown={JS.dispatch("click", to: "#close")} phx-key="escape">
        <%= if @return_to do %>
          <%= live_patch to: @return_to, id: "close", class: "phx-modal-close", phx_click: hide_modal()  do %>
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          <% end %>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end

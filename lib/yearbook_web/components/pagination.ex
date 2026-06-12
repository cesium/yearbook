defmodule YearbookWeb.Components.Pagination do
  @moduledoc """
  UI components for paginated navigation.
  """
  use Phoenix.Component

  alias Plug.Conn.Query
  use Gettext, backend: YearbookWeb.Gettext

  attr :meta, :any, required: true
  attr :params, :map, required: true

  def pagination(assigns) do
    ~H"""
    <nav class="flex items-center justify-between pt-6 pb-2" aria-label="Pagination">
      <span class="text-sm text-gray-500">
        {gettext("Showing")}
        <span class="font-bold text-gray-700">
          {@meta.current_offset + 1}-{@meta.next_offset || @meta.total_count}
        </span>
        {gettext("of")}
        <span class="font-bold text-gray-700">
          {@meta.total_count}
        </span>
      </span>

      <ul class="inline-flex items-center -space-x-px text-sm rounded-lg shadow-sm">
        <.pagination_button
          text={gettext("Previous")}
          left_corner={true}
          disabled={!@meta.has_previous_page?}
          page={@meta.previous_page}
          params={@params}
        />

        <%= if max(1, @meta.current_page - 2) != 1 do %>
          <.pagination_button page={1} params={@params} />
          <li
            :if={max(1, @meta.current_page - 2) > 2}
            class="flex items-center justify-center px-3 h-8 leading-tight text-gray-400 bg-white border border-gray-200 cursor-default"
          >
            ...
          </li>
        <% end %>

        <%= for page <- max(1, @meta.current_page - 2)..max(min(@meta.total_pages, @meta.current_page + 2), 1) do %>
          <.pagination_button page={page} params={@params} is_current={@meta.current_page == page} />
        <% end %>

        <%= if min(@meta.total_pages, @meta.current_page + 2) != @meta.total_pages do %>
          <li
            :if={min(@meta.total_pages, @meta.current_page + 2) < @meta.total_pages - 1}
            class="flex items-center justify-center px-3 h-8 leading-tight text-gray-400 bg-white border border-gray-200 cursor-default"
          >
            ...
          </li>
          <.pagination_button page={@meta.total_pages} params={@params} />
        <% end %>

        <.pagination_button
          text={gettext("Next")}
          right_corner={true}
          disabled={!@meta.has_next_page?}
          page={@meta.next_page}
          params={@params}
        />
      </ul>
    </nav>
    """
  end

  attr :text, :string, default: ""
  attr :disabled, :boolean, default: false
  attr :left_corner, :boolean, default: false
  attr :right_corner, :boolean, default: false
  attr :is_current, :boolean, default: false
  attr :page, :integer
  attr :params, :map

  defp pagination_button(assigns) do
    if assigns.disabled do
      ~H"""
      <li>
        <span class={[
          "flex items-center justify-center px-3 h-8 leading-tight text-gray-400 bg-white border border-gray-200 cursor-not-allowed",
          @right_corner && "rounded-r-lg",
          @left_corner && "rounded-l-lg"
        ]}>
          {if @text == "", do: @page, else: @text}
        </span>
      </li>
      """
    else
      ~H"""
      <li>
        <.link
          patch={build_query("page", @page, @params)}
          class={[
            "flex items-center justify-center px-3 h-8 leading-tight border border-gray-200 transition-colors",
            @right_corner && "rounded-r-lg",
            @left_corner && "rounded-l-lg",
            !@is_current && "text-gray-500 bg-white hover:bg-gray-50 hover:text-gray-700",
            @is_current && "text-gray-800 bg-gray-50 font-medium z-10"
          ]}
        >
          {if @text == "", do: @page, else: @text}
        </.link>
      </li>
      """
    end
  end

  defp build_query(key, value, params) do
    query = Map.put(params, key, value)
    "?#{Query.encode(query)}"
  end
end

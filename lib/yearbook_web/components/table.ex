defmodule YearbookWeb.Components.Table do
  @moduledoc """
  Table component for displaying data in a tabular format.
  """
  use Phoenix.Component

  alias Plug.Conn.Query
  use Gettext, backend: YearbookWeb.Gettext
  import YearbookWeb.CoreComponents

  attr :id, :string, required: true
  attr :items, :list, required: true
  attr :meta, :any, default: nil
  attr :row_id, :any, default: nil
  attr :params, :map, required: true
  attr :row_click, :fun, default: nil
  attr :sortable, :boolean, default: false

  slot :col do
    attr :label, :string, required: false
    attr :sortable, :boolean
    attr :field, :atom
    attr :class, :string
  end

  slot :action do
    attr :label, :string, required: false
  end

  def data_table(assigns) do
    assigns =
      with %{items: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="w-full">
      <div class="border border-gray-200 rounded-xl bg-white overflow-x-auto shadow-sm">
        <table id={@id} class="w-full text-sm text-left text-gray-700 table-fixed">
          <thead class="text-[11px] uppercase text-gray-400 font-semibold tracking-wider border-b border-gray-200 bg-white">
            <tr>
              <.header_column
                :for={col <- @col}
                label={col[:label]}
                sortable={col[:sortable]}
                params={@params}
                field={col[:field]}
                meta={@meta}
                class={col[:class]}
              />
              <.header_column :if={@action != []} class="w-36 text-right" />
            </tr>
          </thead>
          <tbody
            id={@id <> "-tbody"}
            phx-update={match?(%Phoenix.LiveView.LiveStream{}, @items) && "stream"}
            phx-hook={
              if @sortable do
                "Sorting"
              end
            }
            class="divide-y divide-gray-100 bg-white"
          >
            <tr
              :for={item <- @items}
              id={@row_id && @row_id.(item)}
              class={[
                "hover:bg-gray-50/80 transition-colors duration-150 group",
                @row_click && "hover:cursor-pointer"
              ]}
              phx-click={@row_click && @row_click.(item)}
            >
              <td
                :for={col <- @col}
                class={[
                  "px-6 py-4 font-normal text-gray-700",
                  col[:class]
                ]}
              >
                {render_slot(col, item)}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right w-36">
                <div class="flex items-center justify-end gap-3 opacity-70 group-hover:opacity-100 transition-opacity">
                  <span
                    :for={action <- @action}
                    class="text-gray-400 hover:text-gray-700 transition-colors"
                  >
                    {render_slot(action, item)}
                  </span>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <.pagination :if={@meta && @meta.total_pages > 1} meta={@meta} params={@params} />
    </div>
    """
  end

  attr :label, :string, default: ""
  attr :sortable, :boolean, default: false
  attr :params, :map
  attr :field, :atom
  attr :meta, :any, default: nil
  attr :class, :string, default: ""

  defp header_column(assigns) do
    if assigns.sortable do
      assigns =
        Map.put(assigns, :order_direction, order_direction(assigns.meta.flop, assigns.field))

      ~H"""
      <th scope="col" class={["px-6 py-3", @class]}>
        <.link
          patch={next_order_query(@field, @meta.flop, @params)}
          class="inline-flex items-center gap-1.5 hover:text-gray-600 transition-colors"
        >
          {@label}
          <.sort_arrow direction={@order_direction} />
        </.link>
      </th>
      """
    else
      ~H"""
      <th scope="col" class={["px-6 py-3", @class]}>
        {@label}
      </th>
      """
    end
  end

  attr :direction, :atom, required: true

  defp sort_arrow(assigns) do
    ~H"""
    <span class="flex flex-col items-center justify-center -space-y-1.5 text-gray-400">
      <span
        role="img"
        aria-label="caret-up"
        class={[
          "h-3 w-3 inline-flex items-center",
          @direction in [
            :asc,
            :asc_nulls_first,
            :asc_nulls_last,
            "asc",
            "asc_nulls_first",
            "asc_nulls_last"
          ] && "text-gray-800"
        ]}
      >
        <.icon class="w-full h-full stroke-[2.5px]" name="hero-chevron-up" />
      </span>
      <span
        role="img"
        aria-label="caret-down"
        class={[
          "h-3 w-3 inline-flex items-center",
          @direction in [
            :desc,
            :desc_nulls_first,
            :desc_nulls_last,
            "desc",
            "desc_nulls_first",
            "desc_nulls_last"
          ] && "text-gray-800"
        ]}
      >
        <.icon class="w-full h-full stroke-[2.5px]" name="hero-chevron-down" />
      </span>
    </span>
    """
  end

  attr :meta, :any, required: true
  attr :params, :map, required: true

  def pagination(assigns) do
    ~H"""
    <nav class="flex items-center justify-between pt-6 pb-2" aria-label="Table navigation">
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
        <% end %>
        <%= for page <- max(1, @meta.current_page - 2)..max(min(@meta.total_pages, @meta.current_page + 2), 1) do %>
          <.pagination_button page={page} params={@params} is_current={@meta.current_page == page} />
        <% end %>
        <%= if min(@meta.total_pages, @meta.current_page + 2) != @meta.total_pages do %>
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

  defp order_direction(%{order_by: [field | _], order_directions: [direction | _]}, target_field) do
    if to_string(field) == to_string(target_field) do
      normalize_direction(direction)
    end
  end

  defp order_direction(_flop, _target_field), do: nil

  defp normalize_direction(dir) when is_binary(dir), do: String.to_atom(dir)
  defp normalize_direction(dir), do: dir

  defp next_order_query(field, flop, params) do
    flop = flop || %{order_by: [], order_directions: []}
    current_dir = order_direction(flop, field)

    {next_by, next_dir} =
      case current_dir do
        :asc -> {[field], [:desc]}
        :desc -> {[], []}
        _ -> {[field], [:asc]}
      end

    query =
      params
      |> Map.put("order_by", next_by)
      |> Map.put("order_directions", next_dir)

    "?#{Query.encode(query)}"
  end
end

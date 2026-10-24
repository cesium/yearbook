defmodule YearbookWeb.Components.AcademicYear do
  @moduledoc """
  Academic year dropdown.
  """

  use Phoenix.Component

  use Gettext, backend: YearbookWeb.Gettext
  import YearbookWeb.CoreComponents, only: [icon: 1]

  alias Phoenix.LiveView.JS

  attr :year, :string, default: ""
  attr :masters, :string, default: ""
  attr :id, :string, default: "academic-year"

  def academic_year(assigns) do
    ~H"""
    <div class="relative inline-block text-left">
      <button
        type="button"
        phx-click={JS.toggle(to: "##{@id}-dropdown", in: "fade-in-scale", out: "fade-out-scale")}
        phx-click-away={JS.hide(to: "##{@id}-dropdown")}
        class="flex items-center gap-2 bg-white text-main border border-gray-100 px-4 py-1.5 rounded-xl text-sm font-orbitron font-bold focus:outline-none hover:bg-red-50 transition-all shadow-sm"
      >
        <%= if @year == "" do %>
          <span>{gettext("Ano Letivo")}</span>
        <% else %>
          <span>{format_academic_year(String.to_integer(@year))}</span>
        <% end %>
        <.icon name="hero-chevron-down" class="size-4" />
      </button>

      <div
        id={"#{@id}-dropdown"}
        class="hidden absolute right-0 sm:left-0 sm:right-auto mt-2 w-48 origin-top-left rounded-2xl bg-white shadow-xl ring-1 ring-gray-400 ring-opacity-5 z-50 overflow-hidden border border-gray-100"
      >
        <div class="py-2">
          <%= for {label, value} <- list_academic_years() do %>
            <button
              type="button"
              phx-click={
                JS.push("filter_changed", value: %{year: value, masters: @masters})
                |> JS.hide(to: "##{@id}-dropdown")
              }
              class={
                "block w-full text-left px-5 py-2.5 text-sm transition-all #{if @year == value, do: "bg-red-50 text-main font-bold", else: "text-gray-600 hover:bg-gray-50 hover:text-main"}"
              }
            >
              <div class="flex items-center justify-between">
                <span>{label}</span>
                <%= if @year == value do %>
                  <div class="size-1.5 rounded-full bg-main"></div>
                <% end %>
              </div>
            </button>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp list_academic_years do
    current_year = Date.utc_today().year

    years =
      2020..current_year
      |> Enum.map(fn year -> {format_academic_year(year), "#{year}"} end)
      |> Enum.reverse()

    [{gettext("Todos os Anos"), ""} | years]
  end

  defp format_academic_year(year) do
    "#{year - 1}/#{rem(year, 100)}"
  end
end

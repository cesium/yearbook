defmodule YearbookWeb.PageLive do
  use Gettext, backend: YearbookWeb.Gettext
  use YearbookWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # Gettext.put_locale(YearbookWeb.Gettext, "pt")
    # mix gettext.extract
    # mix gettext.merge priv/gettext
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
      {gettext("Hello World")}
    """
  end
end

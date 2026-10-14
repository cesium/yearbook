# lib/yearbook_web/plugs/locale.ex
defmodule YearbookWeb.Plugs.Locale do
  import Plug.Conn

  @supported ["pt", "en"]
  @default "pt"

  def init(opts), do: opts

  def call(conn, _opts) do
    locale =
      conn.params["locale"] ||
        get_session(conn, :locale) ||
        from_accept_language(conn) ||
        @default

    locale = if locale in @supported, do: locale, else: @default

    Gettext.put_locale(YearbookWeb.Gettext, locale)

    conn
    |> put_session(:locale, locale)
    |> assign(:locale, locale)
  end

  defp from_accept_language(conn) do
    conn
    |> get_req_header("accept-language")
    |> List.first("")
    |> String.split(",")
    |> Enum.map(fn part ->
      part |> String.split(";") |> hd() |> String.trim() |> String.slice(0, 2)
    end)
    |> Enum.find(&(&1 in @supported))
  end
end

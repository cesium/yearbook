defmodule YearbookWeb.Plugs.Locale do
  @moduledoc """
  Sets the Gettext locale for each request.

  The locale comes from `?locale=`, then the session, then the browser's
  Accept-Language header, and finally the configured default.
  """

  import Plug.Conn

  @supported ["pt", "en"]

  def init(opts), do: opts

  def call(conn, _opts) do
    locale =
      conn.params["locale"] ||
        get_session(conn, :locale) ||
        from_accept_language(conn) ||
        default_locale()

    locale = normalize_locale(locale)

    Gettext.put_locale(YearbookWeb.Gettext, locale)

    conn
    |> put_session(:locale, locale)
    |> assign(:locale, locale)
  end

  defp normalize_locale(locale) when is_binary(locale) do
    locale = locale |> String.trim() |> String.downcase() |> String.slice(0, 2)

    if locale in @supported, do: locale, else: default_locale()
  end

  defp normalize_locale(_locale), do: default_locale()

  defp default_locale do
    case Application.get_env(:gettext, :default_locale, "pt") do
      locale when locale in @supported -> locale
      _ -> "pt"
    end
  end

  defp from_accept_language(conn) do
    conn
    |> get_req_header("accept-language")
    |> List.first("")
    |> String.split(",")
    |> Enum.map(fn part ->
      part
      |> String.split(";")
      |> hd()
      |> String.trim()
      |> String.slice(0, 2)
      |> String.downcase()
    end)
    |> Enum.find(&(&1 in @supported))
  end
end

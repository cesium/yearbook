defmodule YearbookWeb.LocaleHook do
  @moduledoc """
  Sets the Gettext locale in the LiveView process from the session.
  """

  import Phoenix.Component, only: [assign: 3]

  @supported_locales ["pt", "en"]

  def on_mount(:default, _params, session, socket) do
    locale =
      session
      |> Map.get("locale")
      |> normalize_locale()

    Gettext.put_locale(YearbookWeb.Gettext, locale)

    {:cont, assign(socket, :locale, locale)}
  end

  defp normalize_locale(locale) when locale in @supported_locales, do: locale
  defp normalize_locale(_locale), do: default_locale()

  defp default_locale do
    case Application.get_env(:gettext, :default_locale, "pt") do
      locale when locale in @supported_locales -> locale
      _ -> "pt"
    end
  end
end

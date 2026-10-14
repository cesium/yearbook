defmodule YearbookWeb.LocaleHook do
  import Phoenix.Component, only: [assign: 3]

  def on_mount(:default, _params, session, socket) do
    locale = session["locale"] || "pt"
    Gettext.put_locale(YearbookWeb.Gettext, locale)
    {:cont, assign(socket, :locale, locale)}
  end
end

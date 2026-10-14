defmodule YearbookWeb.PrivacyPolicyLive.Index do
  @moduledoc """
  Privacy Policy Page
  """
  use YearbookWeb, :landing_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Política de Privacidade")}
  end
end

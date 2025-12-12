defmodule YearbookWeb.SignInLive.Index do
  use YearbookWeb, :auth_view

  alias Phoenix.HTML.FormData

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Sign In | Yearbook")
     |> assign(form: FormData.to_form(%{"password" => ""}, as: :auth))}
  end
end

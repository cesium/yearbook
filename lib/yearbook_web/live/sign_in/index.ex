defmodule YearbookWeb.SignInLive.Index do
  use YearbookWeb, :auth_view

  alias Phoenix.HTML.FormData

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Sign In | Yearbook")
     |> assign(form: FormData.to_form(%{"email" => "", "password" => ""}, as: :auth))}
  end

  def handle_info({:log_in_user, user}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Welcome back!")
     |> redirect(to: "/home?user_id=#{user.id}")}
  end
end

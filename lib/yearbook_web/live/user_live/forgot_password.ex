defmodule YearbookWeb.UserLive.ForgotPassword do
  @moduledoc """
  Forgot Password Page
  """
  use YearbookWeb, :auth_view

  @impl true
  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 md:gap-0 md:flex-row h-full w-full p-4">
      <div class="z-10 flex justify-end items-center grow h-full w-full sm:bg-transparent">
        <div class="flex flex-col gap-6 bg-white w-full md:w-125 h-fit rounded-2xl py-8 px-5 md:p-8 my-auto mx-0 md:mx-5 sm:shadow-xl">
          <div class="flex flex-col gap-2">
            <h1 class="text-4xl font-bold tracking-normal text-black">
              {gettext("Redefinir palavra-passe")}
            </h1>
          </div>
          <.form
            :let={f}
            for={@form}
            id="forgot_password"
            action={~p"/users/forgot-password"}
            phx-submit="submit_email"
            phx-trigger-action={@trigger_submit}
            class="flex flex-col gap-4"
          >
            <.input
              field={f[:email]}
              type="email"
              label={gettext("Email")}
              autocomplete="username"
              required
              class="w-full"
            />

            <.button class="w-full h-12 rounded-lg bg-black cursor-pointer text-white font-semibold hover:bg-black/90 transition disabled:opacity-50 disabled:cursor-not-allowed">
              {gettext("Enviar")}
            </.button>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    form = to_form(%{}, as: "user")
    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  @impl true
  def handle_event("submit_email", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end
end

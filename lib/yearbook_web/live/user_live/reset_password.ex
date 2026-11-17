defmodule YearbookWeb.UserLive.ResetPassword do
  @moduledoc """
  Reset Password Page
  """

  use YearbookWeb, :auth_view

  alias Yearbook.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 md:gap-0 md:flex-row h-full w-full p-4">
      <div class="z-10 flex justify-end items-center grow h-full w-full sm:bg-transparent">
        <div class="flex flex-col gap-6 bg-white w-full md:w-125 h-fit rounded-2xl py-8 px-5 md:p-8 my-auto mx-0 md:mx-5 sm:shadow-xl">
          <div class="flex flex-col gap-2">
            <h1 class="text-4xl font-bold tracking-normal text-black">
              {gettext("Redefinir palavra-passe")}
            </h1>
            <p class="text-sm text-neutral-600 pt-2">
              {gettext("Escolhe uma nova palavra-passe para a tua conta.")}
            </p>
          </div>

          <.form
            :let={f}
            for={@form}
            id="reset_password_form"
            action={~p"/users/reset-password"}
            method="post"
            phx-change="validate_password"
            phx-submit="submit_password"
            phx-trigger-action={@trigger_submit}
            class="flex flex-col gap-4"
          >
            <input type="hidden" name="user[token]" value={@token} />
            <.input
              field={f[:new_password]}
              type="password"
              label={gettext("Nova palavra-passe")}
              autocomplete="new-password"
              required
            />
            <.input
              field={f[:new_password_confirmation]}
              type="password"
              label={gettext("Confirmar nova palavra-passe")}
              autocomplete="new-password"
              required
            />
            <.button class="w-full h-12 rounded-lg bg-black cursor-pointer text-white font-semibold hover:bg-black/90 transition disabled:opacity-50 disabled:cursor-not-allowed">
              {gettext("Guardar nova palavra-passe")}
            </.button>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    if user = Accounts.get_user_by_password_reset_token(token) do
      form = to_form(%{}, as: "user")

      {:ok,
       assign(socket,
         user: user,
         token: token,
         form: form,
         trigger_submit: false
       )}
    else
      {:ok,
       socket
       |> put_flash(:error, gettext("This password reset link is invalid or has expired."))
       |> push_navigate(to: ~p"/users/log-in")}
    end
  end

  @impl true
  def handle_event("validate_password", %{"user" => user_params}, socket) do
    form =
      socket.assigns.user
      |> Accounts.change_user_reset_password(user_params, hash_password: false)
      |> Map.put(:action, :validate)
      |> to_form(as: "user")

    {:noreply, assign(socket, :form, form)}
  end

  @impl true
  def handle_event("submit_password", %{"user" => user_params}, socket) do
    case Accounts.change_user_reset_password(socket.assigns.user, user_params) do
      %{valid?: true} = changeset ->
        {:noreply, assign(socket, trigger_submit: true, form: to_form(changeset, as: "user"))}

      changeset ->
        {:noreply, assign(socket, form: to_form(changeset, action: :insert, as: "user"))}
    end
  end
end

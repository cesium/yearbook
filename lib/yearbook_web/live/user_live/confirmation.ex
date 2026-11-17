defmodule YearbookWeb.UserLive.Confirmation do
  use YearbookWeb, :auth_view

  alias Yearbook.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div class="z-10 flex justify-end items-center grow h-full">
      <div class="flex flex-col gap-8 bg-white w-full md:w-150 h-fit rounded-2xl py-8 px-5 sm:p-8 my-auto mx-5">
        <div class="flex flex-col gap-2">
          <h1 class="text-3xl font-bold tracking-normal text-black">Confirm your email</h1>
          <p class="text-base text-neutral-600">
            Confirm your email address for {@user.email} to finish creating your account.
          </p>
        </div>

        <.form
          for={@form}
          id="confirmation_form"
          action={~p"/users/confirm"}
          phx-submit="submit"
          phx-trigger-action={@trigger_submit}
          class="flex flex-col gap-3"
        >
          <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
          <.button
            phx-disable-with="Confirming..."
            class="w-full h-12 rounded-lg bg-black text-white font-semibold hover:bg-black/90 transition disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Confirm email
          </.button>
        </.form>
      </div>
    </div>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    if user = Accounts.get_user_by_confirmation_token(token) do
      form = to_form(%{"token" => token}, as: "user")
      {:ok, assign(socket, user: user, form: form, trigger_submit: false)}
    else
      {:ok,
       socket
       |> put_flash(:error, "The confirmation link is invalid or has expired.")
       |> push_navigate(to: ~p"/users/log-in")}
    end
  end

  @impl true
  def handle_event("submit", %{"user" => params}, socket) do
    {:noreply, assign(socket, form: to_form(params, as: "user"), trigger_submit: true)}
  end
end

defmodule YearbookWeb.UserLive.Confirmation do
  use YearbookWeb, :auth_view

  alias Yearbook.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div class="z-10 flex justify-end items-center grow h-full">
      <div class="flex flex-col gap-8 bg-white w-full md:w-150 h-fit rounded-2xl py-8 px-5 sm:p-8 my-auto mx-5">
        <div class="flex flex-col gap-2">
          <h1 class="text-3xl font-bold tracking-normal text-black">Welcome {@user.email}</h1>
          <p class="text-base text-neutral-600">Confirm your login to continue.</p>
        </div>

        <.form
          :if={!@user.confirmed_at}
          for={@form}
          id="confirmation_form"
          phx-mounted={JS.focus_first()}
          phx-submit="submit"
          action={~p"/users/log-in?_action=confirmed"}
          phx-trigger-action={@trigger_submit}
          class="flex flex-col gap-3"
        >
          <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
          <.button
            name={@form[:remember_me].name}
            value="true"
            phx-disable-with="Confirming..."
            class="w-full h-12 rounded-lg bg-primary text-white font-semibold hover:bg-primary/90 transition disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Confirm and stay logged in
          </.button>
          <.button
            phx-disable-with="Confirming..."
            class="w-full h-12 rounded-lg border border-primary text-primary font-semibold hover:bg-primary/10 transition disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Confirm and log in only this time
          </.button>
        </.form>

        <.form
          :if={@user.confirmed_at}
          for={@form}
          id="login_form"
          phx-submit="submit"
          phx-mounted={JS.focus_first()}
          action={~p"/users/log-in"}
          phx-trigger-action={@trigger_submit}
          class="flex flex-col gap-3"
        >
          <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
          <%= if @current_scope do %>
            <.button
              phx-disable-with="Logging in..."
              class="w-full h-12 rounded-lg bg-primary text-white font-semibold hover:bg-primary/90 transition disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Log in
            </.button>
          <% else %>
            <.button
              name={@form[:remember_me].name}
              value="true"
              phx-disable-with="Logging in..."
              class="w-full h-12 rounded-lg bg-primary text-white font-semibold hover:bg-primary/90 transition disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Keep me logged in on this device
            </.button>
            <.button
              phx-disable-with="Logging in..."
              class="w-full h-12 rounded-lg border border-primary text-primary font-semibold hover:bg-primary/10 transition disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Log me in only this time
            </.button>
          <% end %>
        </.form>

        <p
          :if={!@user.confirmed_at}
          class="rounded-lg border border-primary/40 bg-primary/5 px-4 py-3 text-sm text-primary"
        >
          Tip: If you prefer passwords, you can enable them in the user settings.
        </p>
      </div>
    </div>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    if user = Accounts.get_user_by_magic_link_token(token) do
      form = to_form(%{"token" => token}, as: "user")

      {:ok, assign(socket, user: user, form: form, trigger_submit: false),
       temporary_assigns: [form: nil]}
    else
      {:ok,
       socket
       |> put_flash(:error, "Magic link is invalid or it has expired.")
       |> push_navigate(to: ~p"/users/log-in")}
    end
  end

  @impl true
  def handle_event("submit", %{"user" => params}, socket) do
    {:noreply, assign(socket, form: to_form(params, as: "user"), trigger_submit: true)}
  end
end

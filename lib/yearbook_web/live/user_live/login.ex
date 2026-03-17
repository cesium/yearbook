defmodule YearbookWeb.UserLive.Login do
  use YearbookWeb, :auth_view

  alias Yearbook.Accounts

  import YearbookWeb.Footer

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex h-full w-full p-4">
      <div class="flex flex-col h-full  justify-between">
        <div :if={local_mail_adapter?()} class="alert alert-info bg-white rounded-2xl p-3">
          <.icon name="hero-information-circle" class="size-6 shrink-0" />
          <div>
            <p>You are running the local mail adapter.</p>
            <p>
              To see sent emails, visit <.link href="/dev/mailbox" class="underline">the mailbox page</.link>.
            </p>
          </div>
        </div>
      </div>
      <div class="z-10 flex justify-end items-center grow h-full">
        <div class="flex flex-col gap-8 bg-white w-full md:w-150 h-fit rounded-2xl py-8 px-5 sm:p-8 my-auto mx-5">
          <div class="flex flex-col gap-3">
            <h1 class="text-3xl font-bold tracking-normal text-black">Welcome back</h1>
            <h1 class="text-5xl font-bold tracking-normal text-black">Log in</h1>
            <p class="text-base text-neutral-600 pt-2">
              <%= if @current_scope do %>
                You need to reauthenticate to perform sensitive actions on your account.
              <% else %>
                Don't have an account? <.link
                  navigate={~p"/users/register"}
                  class="font-semibold text-primary underline hover:text-[#E37044] hover:scale-110 transition-all"
                  phx-no-format
                >Sign up</.link>
              <% end %>
            </p>
          </div>

          <.form
            :let={f}
            for={@form}
            id="login_form_magic"
            action={~p"/users/log-in"}
            phx-submit="submit_magic"
            class="flex flex-col gap-4"
          >
            <.input
              readonly={!!@current_scope}
              field={f[:email]}
              type="email"
              label="Email"
              autocomplete="username"
              required
              phx-mounted={JS.focus()}
              class="w-full"
            />
            <.button class="w-full h-12 rounded-lg cursor-pointer bg-primary text-white font-semibold hover:bg-primary/90 transition disabled:opacity-50 disabled:cursor-not-allowed">
              Log in with email <span aria-hidden="true">→</span>
            </.button>
          </.form>
          <div class="flex items-center gap-3 text-sm text-gray-500">
            <div class="h-px flex-1 bg-gray-200"></div>
            <span>or</span>
            <div class="h-px flex-1 bg-gray-200"></div>
          </div>

          <.form
            :let={f}
            for={@form}
            id="login_form_password"
            action={~p"/users/log-in"}
            phx-submit="submit_password"
            phx-trigger-action={@trigger_submit}
            class="flex flex-col gap-4"
          >
            <.input
              readonly={!!@current_scope}
              field={f[:email]}
              type="email"
              label="Email"
              autocomplete="username"
              required
              class="w-full"
            />
            <.input
              field={@form[:password]}
              type="password"
              label="Password"
              autocomplete="current-password"
              class="w-full"
            />
            <.button
              class="w-full h-12 rounded-lg bg-primary cursor-pointer text-white font-semibold hover:bg-primary/90 transition disabled:opacity-50 disabled:cursor-not-allowed"
              name={@form[:remember_me].name}
              value="true"
            >
              Log in and stay logged in <span aria-hidden="true">→</span>
            </.button>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("submit_magic", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_login_instructions(
        user,
        &url(~p"/users/log-in/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions for logging in shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_navigate(to: ~p"/users/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:yearbook, Yearbook.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end

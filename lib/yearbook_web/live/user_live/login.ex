defmodule YearbookWeb.UserLive.Login do
  use YearbookWeb, :auth_view

  alias Yearbook.Accounts

  @impl true
  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 md:gap-0 md:flex-row h-full w-full p-4">
      <div class="flex flex-col h-full justify-between">
        <div
          :if={local_mail_adapter?()}
          class="alert alert-info border-2 border-black bg-white rounded-2xl p-3"
        >
          <.icon name="hero-information-circle" class="size-6 shrink-0" />
          <div>
            <p>{gettext("Está a utilizar o adaptador de email local.")}</p>
            <p>
              {gettext("Para consultar os emails enviados, visite")} <.link
                href="/dev/mailbox"
                class="underline"
              >{gettext("a página da caixa de correio")}</.link>.
            </p>
          </div>
        </div>
      </div>
      <div class="z-10 flex justify-end items-center grow h-full w-full sm:bg-transparent">
        <div class="flex flex-col gap-6 bg-white w-full md:w-125 h-fit rounded-2xl py-8 px-5 md:p-8 my-auto mx-0 md:mx-5 sm:shadow-xl">
          <div class="flex flex-col gap-2">
            <h1 class="text-3xl font-bold tracking-normal text-black">
              {gettext("Bem-vindo de volta")}
            </h1>
            <h1 class="text-4xl font-bold tracking-normal text-black">{gettext("Iniciar sessão")}</h1>
            <p class="text-base text-neutral-600 pt-2">
              <%= if @current_scope do %>
                {gettext("Tem de voltar a autenticar-se para realizar ações sensíveis na sua conta.")}
              <% else %>
                {gettext("Ainda não tem uma conta?")} <.link
                  navigate={~p"/users/register"}
                  class="font-semibold text-black underline hover:text-[#E37044] hover:scale-110 transition-all cursor-pointer"
                  phx-no-format
                >{gettext("Registar-se")}</.link>
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
              label={gettext("Email")}
              autocomplete="username"
              required
              phx-mounted={JS.focus()}
              class="w-full"
            />
            <.button class="w-full h-12 rounded-lg cursor-pointer bg-black text-white font-semibold hover:bg-black/90 transition disabled:opacity-50 disabled:cursor-not-allowed">
              {gettext("Iniciar sessão com email")} <span aria-hidden="true">→</span>
            </.button>
          </.form>
          <div class="flex items-center gap-3 text-sm text-gray-500">
            <div class="h-px flex-1 bg-gray-200"></div>
            <span>{gettext("ou")}</span>
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
              label={gettext("Email")}
              autocomplete="username"
              required
              class="w-full"
            />
            <.input
              field={@form[:password]}
              type="password"
              label={gettext("Palavra-passe")}
              autocomplete="current-password"
              class="w-full"
            />
            <.button
              class="w-full h-12 rounded-lg bg-black cursor-pointer text-white font-semibold hover:bg-black/90 transition disabled:opacity-50 disabled:cursor-not-allowed"
              name={@form[:remember_me].name}
              value="true"
            >
              {gettext("Iniciar sessão e manter sessão iniciada")} <span aria-hidden="true">→</span>
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
      gettext(
        "Se o seu email estiver registado no nosso sistema, receberá em breve instruções para iniciar sessão."
      )

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_navigate(to: ~p"/users/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:yearbook, Yearbook.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end

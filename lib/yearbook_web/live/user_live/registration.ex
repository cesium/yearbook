defmodule YearbookWeb.UserLive.Registration do
  use YearbookWeb, :auth_view

  alias Yearbook.Accounts
  alias Yearbook.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
      <div class="z-10 flex justify-end items-center grow h-full">
        <div class="flex flex-col gap-9 bg-white w-full md:w-150 h-fit rounded-2xl py-8 px-5 sm:p-8 my-auto mx-5">
          <div class="flex flex-col gap-2">
            <h1 class="text-3xl font-bold tracking-normal text-black">Sign up to</h1>
            <h1 class="text-5xl font-bold tracking-normal text-black">Yearbook</h1>
          </div>

          <.form for={@form} id="registration_form" phx-submit="save" phx-change="validate_registration" class="flex flex-col gap-4">
            <.input
              field={@form[:email]}
              type="email"
              label="Email"
              autocomplete="username"
              required
              phx-mounted={JS.focus()}
            />

            <.button
              phx-disable-with="Creating account..."
              class="w-full h-12 rounded-lg bg-primary text-white font-semibold hover:bg-primary/90 transition disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Create an account
            </.button>
          </.form>

          <div class="text-center">
            <span class="text-black">Already have an account? </span>
            <.link
              class="inline-block text-primary underline cursor-pointer hover:text-[#E37044] hover:scale-110 transition-all"
              navigate={~p"/users/log-in"}
            >
              Log in
            </.link>
          </div>
        </div>
      </div>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: YearbookWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_email(%User{}, %{}, validate_unique: false)

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_login_instructions(
            user,
            &url(~p"/users/log-in/#{&1}")
          )

        {:noreply,
         socket
         |> put_flash(
           :info,
           "An email was sent to #{user.email}, please access it to confirm your account."
         )
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate_registration", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_email(%User{}, user_params, validate_unique: false)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("validate_registration", _params, socket) do
    {:noreply, socket}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end

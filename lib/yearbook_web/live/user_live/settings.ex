defmodule YearbookWeb.UserLive.Settings do
  use YearbookWeb, :auth_view

  on_mount {YearbookWeb.UserAuth, :require_authenticated}

  alias Yearbook.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div class="z-10 flex justify-end items-center grow h-full">
      <div class="flex flex-col gap-8 bg-white w-full md:w-150 h-fit rounded-2xl py-8 px-5 sm:p-8 my-auto mx-5">
        <div class="flex flex-col gap-2 text-start">
          <h1 class="text-3xl font-bold tracking-normal text-black">Account Settings</h1>
          <p class="text-base text-neutral-600">
            Manage your account password.
          </p>
        </div>

        <.form
          for={@password_form}
          id="password_form"
          action={~p"/users/update-password"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
          class="flex flex-col gap-4"
        >
          <input
            name={@password_form[:email].name}
            type="hidden"
            id="hidden_user_email"
            autocomplete="username"
            value={@current_email}
          />
          <.input
            field={@password_form[:current_password]}
            type="password"
            label="Current password"
            autocomplete="current-password"
            required
            class="input input-bordered w-full"
          />
          <.input
            field={@password_form[:new_password]}
            type="password"
            label="New password"
            autocomplete="new-password"
            required
            class="input input-bordered w-full"
          />
          <.input
            field={@password_form[:new_password_confirmation]}
            type="password"
            label="Confirm new password"
            autocomplete="new-password"
            class="input input-bordered w-full"
          />
          <.button
            phx-disable-with="Saving..."
            class="w-full h-12 rounded-lg bg-black text-white font-semibold hover:bg-black/90 transition disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Save Password
          </.button>
        </.form>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user
    password_changeset = Accounts.change_user_password(user, %{}, hash_password: false)

    socket =
      socket
      |> assign(:current_email, user.email)
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate_password", params, socket) do
    %{"user" => user_params} = params

    password_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_password(user_params, hash_password: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form)}
  end

  @impl true
  def handle_event("update_password", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user

    case Accounts.change_user_password(user, user_params) do
      %{valid?: true} = changeset ->
        {:noreply, assign(socket, trigger_submit: true, password_form: to_form(changeset))}

      changeset ->
        {:noreply, assign(socket, password_form: to_form(changeset, action: :insert))}
    end
  end
end

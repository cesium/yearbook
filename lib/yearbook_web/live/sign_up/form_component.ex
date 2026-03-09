defmodule YearbookWeb.SignUpLive.FormComponent do
  use YearbookWeb, :live_component

  alias Yearbook.User
  alias Yearbook.Users

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-change="validate" phx-submit="save" phx-target={@myself}>
        <div class="flex flex-col gap-4">
          <%!-- Name --%>
          <div class="flex flex-col gap-3">
            <label class="text-black font-semibold" for={@form[:name].id}>Name</label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2">
              <span class="hero-user text-black"></span>
              <div class="flex-1">
                <input
                  type="text"
                  name={@form[:name].name}
                  id={@form[:name].id}
                  value={@form[:name].value}
                  placeholder="Name"
                  class="w-full border-none focus:ring-0 bg-transparent text-black outline-none h-full"
                />
              </div>
            </div>
            <div :for={error <- @form[:name].errors} class="text-sm text-red-600 mt-1">
              {elem(error, 0)}
            </div>
          </div>

          <%!-- Email --%>
          <div class="flex flex-col gap-3">
            <label class="text-black font-semibold" for={@form[:email].id}>Email</label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2">
              <span class="hero-at-symbol text-black"></span>
              <div class="flex-1">
                <input
                  type="email"
                  name={@form[:email].name}
                  id={@form[:email].id}
                  value={@form[:email].value}
                  placeholder="Email"
                  class="w-full border-none focus:ring-0 bg-transparent text-black outline-none h-full"
                />
              </div>
            </div>
            <div :for={error <- @form[:email].errors} class="text-sm text-red-600 mt-1">
              {elem(error, 0)}
            </div>
          </div>

          <%!-- Password --%>
          <div class="flex flex-col gap-3">
            <label class="text-black font-semibold" for={@form[:password].id}>Password</label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2">
              <span class="hero-key text-black"></span>
              <div class="flex-1">
                <input
                  type="password"
                  name={@form[:password].name}
                  id={@form[:password].id}
                  value={@form[:password].value}
                  placeholder="Password"
                  class="w-full border-none focus:ring-0 bg-transparent text-black outline-none h-full"
                />
              </div>
              <span
                class="cursor-pointer text-black shrink-0 hero-eye"
                phx-hook="PasswordToggle"
                id="password-toggle"
              >
              </span>
            </div>
            <div :for={error <- @form[:password].errors} class="text-sm text-red-600 mt-1">
              {elem(error, 0)}
            </div>
          </div>

          <%!-- Confirm Password --%>
          <div class="flex flex-col gap-3">
            <label class="text-black font-semibold" for={@form[:confirm_password].id}>
              Confirm Password
            </label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2">
              <span class="hero-key text-black"></span>
              <div class="flex-1">
                <input
                  type="password"
                  name={@form[:confirm_password].name}
                  id={@form[:confirm_password].id}
                  value={@form[:confirm_password].value}
                  placeholder="Confirm Password"
                  class="w-full border-none focus:ring-0 bg-transparent text-black outline-none h-full"
                />
              </div>
              <span
                class="cursor-pointer text-black shrink-0 hero-eye"
                phx-hook="PasswordToggle"
                id="confirm-password-toggle"
              >
              </span>
            </div>
            <div :for={error <- @form[:confirm_password].errors} class="text-sm text-red-600 mt-1">
              {elem(error, 0)}
            </div>
          </div>
        </div>

        <%!-- Submit Button --%>
        <div class="flex flex-col gap-2 mt-2">
          <.button
            type="submit"
            class="h-12 w-full hover:scale-101 transition-transform bg-primary rounded"
            variant="primary"
          >
            Sign up
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("validate", %{"auth" => user_params}, socket) do
    changeset =
      %User{}
      |> Users.change_user_registration(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset, as: "auth"))}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"auth" => user_params}, socket) do
    case Users.register_user(user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account created successfully!")
         |> push_navigate(to: ~p"/signin")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, as: "auth"))}
    end
  end

  @impl true
  def handle_event("save", _params, socket) do
    {:noreply, socket}
  end
end

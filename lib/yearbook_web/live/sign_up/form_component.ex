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
          <div class="flex flex-col gap-1">
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
            <div class="h-5 mt-0.5">
              <span
                :if={@form[:name].errors != []}
                class="text-sm text-red-600"
              >
                {elem(hd(@form[:name].errors), 0)}
              </span>
            </div>
          </div>

          <%!-- Email --%>
          <div class="flex flex-col gap-1">
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
            <div class="h-5 mt-0.5">
              <span
                :if={@form[:email].errors != []}
                class="text-sm text-red-600"
              >
                {elem(hd(@form[:email].errors), 0)}
              </span>
            </div>
          </div>

          <%!-- Password --%>
          <div class="flex flex-col gap-1">
            <label class="text-black font-semibold" for={@form[:password].id}>Password</label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2 w-full">
              <span class="hero-key text-black"></span>
              <div class="flex justify-between flex-1 items-center">
                <input
                  type={if @password_visible, do: "text", else: "password"}
                  name={@form[:password].name}
                  id={@form[:password].id}
                  value={@form[:password].value}
                  placeholder="Password"
                  class="w-full border-none focus:ring-0 bg-transparent text-black outline-none h-full"
                />
                <span
                  id="toggle-eye-password"
                  class={[
                    "cursor-pointer hover:scale-110 transition-transform text-black shrink-0",
                    if(@password_visible, do: "hero-eye-slash", else: "hero-eye")
                  ]}
                  phx-click="toggle_password"
                  phx-target={@myself}
                >
                </span>
              </div>
            </div>
            <div class="h-5 mt-0.5">
              <span
                :if={@form[:password].errors != []}
                class="text-sm text-red-600"
              >
                {elem(hd(@form[:password].errors), 0)}
              </span>
            </div>
          </div>

          <%!-- Confirm Password --%>
          <div class="flex flex-col gap-1">
            <label class="text-black font-semibold" for={@form[:confirm_password].id}>
              Confirm Password
            </label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2 w-full">
              <span class="hero-key text-black"></span>
              <div class="flex justify-between flex-1 items-center">
                <input
                  type={if @confirm_password_visible, do: "text", else: "password"}
                  name={@form[:confirm_password].name}
                  id={@form[:confirm_password].id}
                  value={@form[:confirm_password].value}
                  placeholder="Confirm Password"
                  class="w-full border-none focus:ring-0 bg-transparent text-black outline-none h-full"
                />
                <span
                  id="toggle-eye-confirm-password"
                  class={[
                    "cursor-pointer hover:scale-110 transition-transform text-black shrink-0",
                    if(@confirm_password_visible, do: "hero-eye-slash", else: "hero-eye")
                  ]}
                  phx-click="toggle_confirm_password"
                  phx-target={@myself}
                >
                </span>
              </div>
            </div>
            <div class="h-5 mt-0.5">
              <span
                :if={@form[:confirm_password].errors != []}
                class="text-sm text-red-600"
              >
                {elem(hd(@form[:confirm_password].errors), 0)}
              </span>
            </div>
          </div>
        </div>

        <%!-- Submit Button --%>
        <div class="flex flex-col gap-2 mt-4">
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
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:password_visible, fn -> false end)
     |> assign_new(:confirm_password_visible, fn -> false end)}
  end

  @impl true
  def handle_event("toggle_password", _params, socket) do
    {:noreply, assign(socket, :password_visible, !socket.assigns.password_visible)}
  end

  @impl true
  def handle_event("toggle_confirm_password", _params, socket) do
    {:noreply,
     assign(socket, :confirm_password_visible, !socket.assigns.confirm_password_visible)}
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

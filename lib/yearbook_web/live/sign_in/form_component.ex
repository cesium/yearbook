defmodule YearbookWeb.SignInLive.FormComponent do
  use YearbookWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-change="validate" phx-submit="save" phx-target={@myself}>
        <div class="flex flex-col gap-3">
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
            <div :for={error <- @form[:password].errors} class="text-sm text-red-600 mt-1">
              {elem(error, 0)}
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
            Sign in
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
     |> assign_new(:password_visible, fn -> false end)}
  end

  @impl true
  def handle_event("toggle_password", _params, socket) do
    {:noreply, assign(socket, :password_visible, !socket.assigns.password_visible)}
  end

  @impl true
  def handle_event("validate", %{"auth" => form}, socket) do
    {:noreply,
     socket
     |> assign(
       form: to_form(%{"email" => form["email"], "password" => form["password"]}, as: "auth")
     )}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"auth" => %{"email" => email, "password" => password}}, socket) do
    case Yearbook.Users.get_user_by_email_and_password(email, password) do
      %Yearbook.User{} = user ->
        send(self(), {:log_in_user, user})
        {:noreply, socket}

      nil ->
        {:noreply,
         socket
         |> put_flash(:error, "Invalid email or password")
         |> assign(form: to_form(%{"email" => email, "password" => ""}, as: "auth"))}
    end
  end

  @impl true
  def handle_event("save", _params, socket) do
    {:noreply, put_flash(socket, :error, "Please fill in all fields")}
  end
end

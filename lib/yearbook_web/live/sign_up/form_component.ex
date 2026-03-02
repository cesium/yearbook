defmodule YearbookWeb.SignUpLive.FormComponent do
  use YearbookWeb, :live_component

  alias Yearbook.User

  @impl true
  def render(assigns) do
    ~H"""
    <div >
      <.form for={@form} phx-change="validate" phx-target={@myself} >
        <div class="flex flex-col gap-4">
          <%!-- Name --%>
          <div class="flex flex-col gap-3">
            <label class="text-black font-semibold">Name</label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2">
              <span class="hero-user text-black"></span>
              <.input
                field={@form[:name]}
                placeholder="Name"
                container_class="flex-1"
                class="w-full border-none focus:ring-0 bg-transparent text-black outline-none"
              />
            </div>
          </div>

          <%!-- Email --%>
          <div class="flex flex-col gap-3">
            <label class="text-black font-semibold">Email</label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2">
              <span class="hero-at-symbol text-black"></span>
              <.input
                field={@form[:email]}
                type="email"
                placeholder="Email"
                container_class="flex-1"
                class="w-full border-none focus:ring-0 bg-transparent text-black outline-none"
              />
            </div>
          </div>

          <%!-- Password --%>
          <div class="flex flex-col gap-3">
            <label class="text-black font-semibold">Password</label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2">
              <span class="hero-key text-black"></span>
              <div class="flex flex-1 items-center">
                <.input
                  field={@form[:password]}
                  type={if @password_visible, do: "text", else: "password"}
                  placeholder="Password"
                  container_class="flex-1"
                  class="w-full border-none focus:ring-0 bg-transparent text-black outline-none"
                />
                <span
                  class={[
                    "cursor-pointer text-black shrink-0",
                    if(@password_visible, do: "hero-eye-slash", else: "hero-eye")
                  ]}
                  phx-click="toggle_password"
                  phx-target={@myself}
                >
                </span>
              </div>
            </div>
          </div>

          <%!-- Confirm Password  --%>
          <div class="flex flex-col gap-3">
            <label class="text-black font-semibold">Confirm Password</label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2">
              <span class="hero-key text-black"></span>
              <div class="flex flex-1 items-center">
                <.input
                  field={@form[:confirm_password]}
                  type={if @confirm_password_visible, do: "text", else: "password"}
                  placeholder="Confirm Password"
                  container_class="flex-1"
                  class="w-full border-none focus:ring-0 bg-transparent text-black outline-none"
                />
                <span
                  class={[
                    "cursor-pointer text-black shrink-0",
                    if(@confirm_password_visible, do: "hero-eye-slash", else: "hero-eye")
                  ]}
                  phx-click="toggle_confirm_password"
                  phx-target={@myself}
                >
                </span>
              </div>
            </div>
          </div>
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
  def handle_event("validate", %{"auth" => form}, socket) do
    changeset = %User{} |> User.changeset(form)

    {:noreply,
     socket
     |> assign(form: to_form(changeset, as: "auth"))}
  end
end

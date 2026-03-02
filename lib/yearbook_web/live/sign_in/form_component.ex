defmodule YearbookWeb.SignInLive.FormComponent do
  use YearbookWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-change="validate" phx-target={@myself}>
        <div class="flex flex-col gap-3">
          <%!-- Email --%>
          <div class="flex flex-col gap-3">
            <label class="text-black font-semibold">Email</label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2">
              <span class="hero-at-symbol text-black"></span>
              <.input
                field={@form[:email]}
                type="email"
                placeholder="Email"
                class="w-full border-none focus:ring-0 bg-transparent text-black"
                container_class="flex-1"
              />
            </div>
          </div>
          <%!-- Password --%>
          <div class="flex flex-col gap-3">
            <label class="text-black font-semibold">Password</label>
            <div class="flex items-center border border-gray-300 rounded px-3 h-13 gap-2 w-full">
              <span class="hero-key text-black"></span>
              <div class="flex justify-between flex-1 items-center">
                <.input
                  type={if @password_visible, do: "text", else: "password"}
                  field={@form[:password]}
                  placeholder="Password"
                  container_class="flex-1"
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
end

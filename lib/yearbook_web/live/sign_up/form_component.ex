defmodule YearbookWeb.SignUpLive.FormComponent do
  use YearbookWeb, :live_component

  alias Phoenix.HTML.FormData

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-change="validate" phx-target={@myself}>
        <div class="mb-2 mt-4">
          <label class="text-black font-semibold mb-2 mt-4">Password</label>
          <div class="flex items-center border border-gray-300 rounded px-3 py-2 mb-4 mt-2 h-13">
            <span class="hero-key text-black content-center my-auto mr-2"></span>

            <%= if @password_visible do %>
              <div class="grid w-full h-full grid-cols-[auto_1rem] justify-stretch py-1 pr-2">
                <.input
                  type="text"
                  class="text-black outline-none"
                  placeholder="Password"
                  field={@form["password"]}
                />
                <span
                  id="toggle-eye-password"
                  class="hero-eye text-black cursor-pointer my-auto hover:scale-110 transition-transform"
                  phx-click="toggle_password"
                  phx-target={@myself}
                >
                </span>
              </div>
            <% else %>
              <div class="grid w-full h-full grid-cols-[auto_1rem] justify-stretch py-1 pr-2">
                <.input
                  type="password"
                  class="text-black outline-none"
                  placeholder="Password"
                  field={@form["password"]}
                />
                <span
                  id="toggle-eye-password"
                  class="hero-eye text-black cursor-pointer my-auto hover:scale-110 transition-transform"
                  phx-click="toggle_password"
                  phx-target={@myself}
                >
                </span>
              </div>
            <% end %>
          </div>
        </div>

        <div class="mb-4 mt-4">
          <label class="text-black font-semibold mb-2 mt-4">Confirm Password</label>
          <div class="flex items-center border border-gray-300 rounded px-3 py-2 mb-4 mt-2 h-13">
            <span class="hero-key text-black content-center my-auto mr-2"></span>

            <%= if @confirm_password_visible do %>
              <div class="grid w-full h-full grid-cols-[auto_1rem] justify-stretch py-1 pr-2">
                <.input
                  type="text"
                  class="text-black w-full outline-none"
                  placeholder="Confirm Password"
                  field={@form["confirm_password"]}
                />
                <span
                  class="hero-eye text-black cursor-pointer my-auto hover:scale-110 transition-transform"
                  phx-click="toggle_confirm_password"
                  phx-target={@myself}
                >
                </span>
              </div>
            <% else %>
              <div class="grid w-full h-full grid-cols-[auto_1rem] justify-stretch py-1 pr-2">
                <.input
                  id="confirm-password-input"
                  type="password"
                  class="text-black w-full outline-none"
                  placeholder="Confirm Password"
                  field={@form["confirm_password"]}
                />
                <span
                  id="toggle-eye-confirm"
                  class="hero-eye text-black cursor-pointer my-auto hover:scale-110 transition-transform"
                  phx-click="toggle_confirm_password"
                  phx-target={@myself}
                >
                </span>
              </div>
            <% end %>
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

  def handle_event("validate", %{"auth" => form}, socket) do
    {:noreply,
     socket
     |> assign(
       form:
         FormData.to_form(
           %{"password" => form["password"], "confirm_password" => form["confirm_password"]},
           as: :auth
         )
     )}
  end
end

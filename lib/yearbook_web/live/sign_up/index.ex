defmodule YearbookWeb.SignUpLive.Index do
  use YearbookWeb, :auth_view

  alias Phoenix.HTML.FormData

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Sign Up | Yearbook")
     |> assign(form: FormData.to_form(%{"password" => "", "confirm_password" => ""}, as: :auth))}
  end

  def input(assigns) do
    ~H"""
    <div class="fieldset w-full h-full">
      <label>
        <span :if={@label} class="label mb-1">{@label}</span>
        <input
          type={@type}
          name={@name}
          id={@id}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[
            @class || "w-full input",
            @errors != [] && (@error_class || "input-error")
          ]}
          {@rest}
        />
      </label>
    </div>
    """
  end
end

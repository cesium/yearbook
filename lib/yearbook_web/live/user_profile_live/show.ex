defmodule YearbookWeb.UserProfileLive.Show do

    use YearbookWeb, :live_view

    alias Yearbook.Accounts
    alias Yearbook.Uploaders

    def mount(%{"id" => id}, _session, socket) do
        {:ok, socket}
    end

    def handle_params(%{"id" => id}, _session, socket) do
        {:noreply,
        socket
        |> assign(:user, Accounts.get_user!(id, [classes: [:degree, :academic_year]]))}
    end
end

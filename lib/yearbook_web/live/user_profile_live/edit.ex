defmodule YearbookWeb.UserProfileLive.Edit do
    
    use YearbookWeb, :live_view

    alias Yearbook.Accounts

    def mount(_params, _session, socket) do
        {:ok, socket}
    end

end
defmodule YearbookWeb.Config do
  @moduledoc """
  Web configuration for the app.
  """
  def backoffice_pages do
    [
      %{
        key: :request_approvals,
        title: "Request Approvals",
        icon: "hero-pencil",
        url: "/backoffice/approvals"
      }
    ]
  end
end

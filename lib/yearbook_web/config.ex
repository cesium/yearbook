defmodule YearbookWeb.Config do
  @moduledoc """
  Web configuration for the app.
  """
  def backoffice_pages do
    [
      %{
        key: :mock,
        title: "Mock",
        icon: "hero-pencil",
        url: "/backoffice/mock"
      }
    ]
  end
end

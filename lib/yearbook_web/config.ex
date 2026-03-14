defmodule YearbookWeb.Config do
  @moduledoc """
  Web configuration for the app.
  """
  def backoffice_pages do
    [
      %{
        key: :approvals,
        title: "Approvals",
        icon: "hero-pencil",
        url: "/backoffice/approvals"
      },
      %{
        key: :page,
        title: "Year",
        icon: "hero-pencil",
        url: "/backoffice/year"
      }
    ]
  end
end

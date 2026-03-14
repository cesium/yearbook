defmodule YearbookWeb.Config do



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

defmodule YearbookWeb.HomeLive.Index do
  use YearbookWeb, :landing_view

  @moduledoc """
    Landing Page
  """
  def mount(_params, _session, socket) do
    {:ok,
   ﻿
﻿
Welcome back!
﻿  socket
     |> assign(page_title: "Home | Yearbook")}
  end
end

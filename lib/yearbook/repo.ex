defmodule Yearbook.Repo do
  use Ecto.Repo,
    otp_app: :yearbook,
    adapter: Ecto.Adapters.SQLite3
end

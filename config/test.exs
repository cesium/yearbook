import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :argon2_elixir, t_cost: 1, m_cost: 8

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :yearbook, Yearbook.Repo,
  database: "yearbook_test.db",
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :yearbook, YearbookWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "3tRyYkL6Xkk1hJeoEANSKKYA0Y3THG3lE/EfMNtzbQhgNu/C4QItD7ie7uUBTghJ",
  server: false

# In test we don't send emails.
config :yearbook, Yearbook.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

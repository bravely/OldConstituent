use Mix.Config

# Configure your database
config :constituent, Constituent.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "constituent_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  types: Constituent.PostgresTypes

config :argon2_elixir,
  t_cost: 2,
  m_cost: 12

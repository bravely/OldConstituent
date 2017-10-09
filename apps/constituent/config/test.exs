use Mix.Config

# Configure your database
config :constituent, Constituent.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "constituent_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

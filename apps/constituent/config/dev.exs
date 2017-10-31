use Mix.Config

# Configure your database
config :constituent, Constituent.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "constituent_dev",
  hostname: "localhost",
  pool_size: 10,
  types: Constituent.PostgresTypes

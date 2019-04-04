use Mix.Config

config :constituent, ecto_repos: [Constituent.Repo]

config :geo_postgis,
  json_library: Jason

config :constituent, Constituent.Repo, types: Constituent.PostgresTypes

import_config "#{Mix.env()}.exs"

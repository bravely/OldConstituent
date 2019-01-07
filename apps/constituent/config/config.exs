use Mix.Config

config :constituent, ecto_repos: [Constituent.Repo]

config :constituent, Constituent.Repo, types: Constituent.PostgresTypes

import_config "#{Mix.env()}.exs"

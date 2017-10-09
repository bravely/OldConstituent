use Mix.Config

config :constituent, ecto_repos: [Constituent.Repo]

import_config "#{Mix.env}.exs"

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :constituent_web,
  namespace: ConstituentWeb,
  ecto_repos: [Constituent.Repo]

# Configures the endpoint
config :constituent_web, ConstituentWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ihQ8seUeCDGpiwJFa+ml6x6kw9Lj14mCBb1k3JcrthOnkgwTii9T9Fj+QhBLP1cF",
  render_errors: [view: ConstituentWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ConstituentWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :constituent_web, :generators,
  context_app: :constituent

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

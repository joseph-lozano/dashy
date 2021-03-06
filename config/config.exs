# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :dashy, DashyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KGRc/oVxSGcP/DOMfil555YNvcfHyMpJuq/uobcebd1+3w+++M0jJztJtVjMEJaf",
  render_errors: [view: DashyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Dashy.PubSub,
  live_view: [signing_salt: "AssUml20"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :dashy, Dashy.NYTimes, api_key: System.get_env("NYTIMES_API_KEY")

config :dashy, Dashy.Github,
  api_key: System.get_env("GITHUB_TOKEN"),
  username: System.get_env("GITHUB_USERNAME"),
  orgs: ["testdouble", "fast-radius"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tattler,
  ecto_repos: [Tattler.Repo]

# Configures the endpoint
config :tattler, TattlerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "X3u1oP/iW20bc4XDnQMaG8w3ogICmqirIFlrCnzV4isjuHx8Uez6DWNnw6+xdt4c",
  render_errors: [view: TattlerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Tattler.PubSub,
  live_view: [signing_salt: "LCaGUcBM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

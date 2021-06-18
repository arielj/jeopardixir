# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :jeopardixir,
  ecto_repos: [Jeopardixir.Repo]

# Configures the endpoint
config :jeopardixir, JeopardixirWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kfOVRcLMPijI+kG8OSyCjLC+8oJAHduLnKXmpviWS/NDQItdfkwbN5sshgooqg7A",
  render_errors: [view: JeopardixirWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Jeopardixir.PubSub,
  live_view: [signing_salt: "6JnKc6AS"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

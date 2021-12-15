# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

defmodule ReadDotenv do
  # processes a line setting the env variable only if not present
  defp put_env_var(""), do: "" # do nothing if line is empty
  defp put_env_var(line) do
    [var_name, var_value] = String.split(line, "=", parts: 2)
    unless System.get_env(var_name) do
      System.put_env(var_name, var_value)
    end
  end

  # parse and process each line
  defp put_env_vars(content) do
    content
    |> String.split("\n")
    |> Enum.each(&put_env_var/1)
  end

  # check if file existes and process its content
  defp load_file(file_path) do
    if File.exists?(file_path) do
      case File.read(file_path) do
        {:ok, content} -> put_env_vars(content)
      end
    end
  end

  # load the .env* files
  def load! do
    [".env.#{Mix.env()}", ".env"]
    |> Enum.each(&load_file/1)
  end
end

ReadDotenv.load!

config :jeopardixir,
  ecto_repos: [Jeopardixir.Repo]

# Configures the endpoint
config :jeopardixir, JeopardixirWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kfOVRcLMPijI+kG8OSyCjLC+8oJAHduLnKXmpviWS/NDQItdfkwbN5sshgooqg7A",
  render_errors: [view: JeopardixirWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Jeopardixir.PubSub,
  live_view: [signing_salt: "6JnKc6AS"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.13.5",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

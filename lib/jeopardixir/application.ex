defmodule Jeopardixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    unless Mix.env == :prod do
      Dotenv.load
      Mix.Task.run("loadconfig")
    end

    children = [
      # Start the Ecto repository
      Jeopardixir.Repo,
      # Start the Telemetry supervisor
      JeopardixirWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Jeopardixir.PubSub},
      # Start the Endpoint (http/https)
      JeopardixirWeb.Endpoint
      # Start a worker by calling: Jeopardixir.Worker.start_link(arg)
      # {Jeopardixir.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jeopardixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    JeopardixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

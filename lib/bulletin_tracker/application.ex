defmodule BulletinTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      BulletinTracker.Repo,
      # Start the Telemetry supervisor
      BulletinTrackerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BulletinTracker.PubSub},
      {BulletinTracker.ContentFetchingJob, {"", :content_fetching_job}},
      # Start the Endpoint (http/https)
      BulletinTrackerWeb.Endpoint
      # Start a worker by calling: BulletinTracker.Worker.start_link(arg)
      # {BulletinTracker.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BulletinTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BulletinTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

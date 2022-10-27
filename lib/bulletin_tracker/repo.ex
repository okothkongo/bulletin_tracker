defmodule BulletinTracker.Repo do
  use Ecto.Repo,
    otp_app: :bulletin_tracker,
    adapter: Ecto.Adapters.Postgres
end

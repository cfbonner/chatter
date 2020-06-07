defmodule Tattler.Repo do
  use Ecto.Repo,
    otp_app: :tattler,
    adapter: Ecto.Adapters.Postgres
end

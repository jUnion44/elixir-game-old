defmodule Elixirgame.Repo do
  use Ecto.Repo,
    otp_app: :elixirgame,
    adapter: Ecto.Adapters.Postgres
end

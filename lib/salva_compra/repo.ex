defmodule SalvaCompra.Repo do
  use Ecto.Repo,
    otp_app: :salva_compra,
    adapter: Ecto.Adapters.Postgres
end

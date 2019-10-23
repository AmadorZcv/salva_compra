defmodule SalvaCompraWeb.ConfigController do
  use SalvaCompraWeb, :controller
  alias SalvaCompra.Produtos

  def list_produtos(conn, _) do
    revenda = Produtos.list_revenda()
    consumidor = Produtos.list_consumidor()

    conn
    |> put_status(:ok)
    |> render("produtos.json", %{revenda: revenda, consumidor: consumidor})
  end
end

defmodule SalvaCompra.Produtos do
  alias SalvaCompra.Carrinho

  def list_revenda() do
    Carrinho.ProdutosRevenda.produtos()
  end

  def list_consumidor() do
    Carrinho.Produtos.produtos()
  end
end

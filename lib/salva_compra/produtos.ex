defmodule SalvaCompra.Produtos do
  alias SalvaCompra.Carrinho

  def list_revenda() do
    Carrinho.ProdutosRevenda.produtos()
  end

  def list_consumidor() do
    Carrinho.Produtos.produtos()
  end

  def list_is_consumidor(is_consumidor) do
    if is_consumidor do
      list_consumidor()
    else
      list_revenda()
    end
  end
end

defmodule SalvaCompraWeb.ConfigView do
  use SalvaCompraWeb, :view

  def render("produtos.json", %{revenda: revenda, consumidor: consumidor}) do
    %{
      revenda: revenda,
      consumidor: consumidor
    }
  end
end

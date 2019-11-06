defmodule SalvaCompraWeb.OrcamentoView do
  use SalvaCompraWeb, :view
  alias SalvaCompraWeb.OrcamentoView

  defp orcamentos_to_map(orcamentos) do
    Enum.reduce(orcamentos, %{}, fn orcamento, map ->
      # Pegando somente a parte identificadora do dia
      title = String.slice(orcamento.title, 0..7)
      orcamento_json = render_one(orcamento, OrcamentoView, "orcamento.json")
      new_map = Map.put_new(map, title, %{})
      orcamentos_map = Map.put(new_map[title], orcamento.title, orcamento_json)

      Map.put(new_map, title, orcamentos_map)
    end)
  end

  def render("index.json", %{orcamentos: orcamentos}) do
    %{data: orcamentos_to_map(orcamentos)}
  end

  def render("show.json", %{orcamento: orcamento, html: html}) do
    %{data: %{orcamento: render_one(orcamento, OrcamentoView, "orcamento.json"), html: html}}
  end

  def render("produto.json", %{produto: produto}) do
    %{
      ipi: produto.ipi,
      ipic: produto.ipic,
      preco: produto.preco,
      produto_id: produto.produto_id,
      total: produto.total,
      qtd: produto.qtd
    }
  end

  def render("orcamento.json", %{orcamento: orcamento}) do
    %{
      id: orcamento.id,
      criacao: orcamento.criacao,
      validade: orcamento.validade,
      condicao: orcamento.condicao,
      telefone: orcamento.telefone,
      cidade: orcamento.cidade,
      nome: orcamento.nome,
      nome_completo: orcamento.nome_completo,
      uf: orcamento.uf,
      cpf: orcamento.cpf,
      email: orcamento.email,
      ramo: orcamento.ramo,
      parcela: orcamento.parcela,
      title: orcamento.title,
      produtos:
        Enum.map(orcamento.produtos, fn produto -> render("produto.json", %{produto: produto}) end)
    }
  end
end

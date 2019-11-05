defmodule SalvaCompraWeb.OrcamentoView do
  use SalvaCompraWeb, :view
  alias SalvaCompraWeb.OrcamentoView

  def render("index.json", %{orcamentos: orcamentos}) do
    %{data: render_many(orcamentos, OrcamentoView, "orcamento.json")}
  end

  def render("show.json", %{orcamento: orcamento, html: html}) do
    %{data: %{orcamento: render_one(orcamento, OrcamentoView, "orcamento.json"), html: html}}
  end

  def render("produto.json", %{produto: produto}) do
    %{
      ipi: produto.ipi,
      ipic: produto.ipic,
      preco: produto.preco,
      produto_id: produto.id,
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

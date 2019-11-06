defmodule SalvaCompraWeb.V1.OrcamentoController do
  use SalvaCompraWeb, :controller

  alias SalvaCompra.Orcamentos
  alias SalvaCompra.Orcamentos.Orcamento
  action_fallback SalvaCompraWeb.FallbackController

  def create(conn, %{
        "orcamento" => %{
          "criacao" => criacao,
          "validade" => validade,
          "condicao" => condicao,
          "telefone" => telefone,
          "cidade" => cidade,
          "nome" => nome,
          "nome_completo" => nome_completo,
          "uf" => uf,
          "cpf" => cpf,
          "email" => email,
          "ramo" => ramo,
          "parcela" => parcela,
          "produtos" => produtos,
          "title" => title,
          "obs" => obs
        }
      }) do
    day_id =
      String.split(title, "-")
      |> Enum.at(1)
      |> String.to_integer()

    with {:ok, %Orcamento{} = orcamento} <-
           Orcamentos.create_orcamento_v1(%{
             cidade: cidade,
             condicao: condicao,
             cpf: cpf,
             criacao: criacao,
             email: email,
             nome: nome,
             nome_completo: nome_completo,
             parcela: String.to_integer(parcela),
             ramo: ramo,
             telefone: telefone,
             uf: uf,
             validade: validade,
             produtos: produtos,
             user_id: conn.assigns[:user_id],
             title: title,
             obs: obs,
             day_id: day_id
           }) do
      html = Orcamentos.orcamento_to_html(orcamento, conn)

      conn
      |> put_status(:created)
      |> render("show.json", orcamento: orcamento, html: html)
    end
  end
end

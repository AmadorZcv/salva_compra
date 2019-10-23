defmodule SalvaCompraWeb.OrcamentoController do
  use SalvaCompraWeb, :controller

  alias SalvaCompra.Orcamentos
  alias SalvaCompra.Orcamentos.Orcamento
  action_fallback SalvaCompraWeb.FallbackController

  def index(conn, _params) do
    orcamentos = Orcamentos.list_orcamentos()
    render(conn, "index.json", orcamentos: orcamentos)
  end

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
          "carrinho" => carrinho,
          "parcela" => parcela
        }
      }) do
    data = SalvaCompra.Carrinho.Produtos.produtos()

    produtos_orcamento =
      Enum.map(carrinho, fn item ->
        produto = data[item["id"]]
        ipic = floor(produto.preco * (produto.ipi / 100))

        %{
          produto_id: produto.id,
          preco: produto.preco,
          qtd: item["qtd"],
          total: produto.preco + ipic,
          ipi: produto.ipi,
          ipic: ipic
        }
      end)

    with {:ok, %Orcamento{} = orcamento} <-
           Orcamentos.create_orcamento(%{
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
             produtos: produtos_orcamento,
             user_id: conn.assigns[:user_id]
           }) do
      html = Orcamentos.orcamento_to_html(orcamento, conn)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.orcamento_path(conn, :show, orcamento))
      |> render("show.json", orcamento: orcamento, html: html)
    end
  end

  def show(conn, %{"id" => id}) do
    orcamento = Orcamentos.get_orcamento!(id)
    html = Orcamentos.orcamento_to_html(orcamento, conn)
    render(conn, "show.json", orcamento: orcamento, html: html)
  end

  def update(conn, %{"id" => id, "orcamento" => orcamento_params}) do
    orcamento = Orcamentos.get_orcamento!(id)

    with {:ok, %Orcamento{} = orcamento} <-
           Orcamentos.update_orcamento(orcamento, orcamento_params) do
      render(conn, "show.json", orcamento: orcamento)
    end
  end

  def delete(conn, %{"id" => id}) do
    orcamento = Orcamentos.get_orcamento!(id)

    with {:ok, %Orcamento{}} <- Orcamentos.delete_orcamento(orcamento) do
      send_resp(conn, :no_content, "")
    end
  end
end

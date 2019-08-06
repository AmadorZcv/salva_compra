defmodule SalvaCompraWeb.PageController do
  use SalvaCompraWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def pdf(conn, _params) do
    render(conn, "new_pdf.html", %{
      conn: conn,
      ntp: Images64.logo_ntp(),
      salva: Images64.logo_salva()
    })
  end

  def print(conn, %{
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
          "carrinho" => carrinho
        }
      }) do
    data = SalvaCompra.Carrinho.Produtos.produtos()

    produtos =
      Enum.map(carrinho, fn produto ->
        item = data[produto["id"]]

        %{
          nome: item.nome,
          preco: item.preco,
          qtd: produto["qtd"],
          total: item.total,
          ipi: item.ipi
        }
      end)

    total = Enum.reduce(produtos, 0, fn produto, acc -> produto.total + acc end)

    html =
      Phoenix.View.render_to_string(SalvaCompraWeb.PageView, "new_pdf.html", %{
        conn: conn,
        ntp: Images64.logo_ntp(),
        salva: Images64.logo_salva(),
        criacao: criacao,
        validade: validade,
        condicao: condicao,
        telefone: telefone,
        cidade: cidade,
        nome: nome,
        nome_completo: nome_completo,
        uf: uf,
        cpf: cpf,
        email: email,
        ramo: ramo,
        carrinho: carrinho,
        produtos: produtos,
        total: total
      })

    conn
    |> send_resp(200, html)

    # {:ok, filename} = PdfGenerator.generate(html)
  end
end

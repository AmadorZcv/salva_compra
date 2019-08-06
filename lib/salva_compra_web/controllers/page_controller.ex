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

    # {:ok, filename} = PdfGenerator.generate(html)
    {:ok, filename} =
      PdfGenerator.generate(html,
        generator: :chrome,
        prefer_system_executable: true,
        shell_params: [
          "--chrome-binary",
          "node_modules/puppeteer/.local-chromium/linux-674921/chrome-linux/chrome"
        ]
      )

    conn
    |> put_resp_content_type("application/octet-stream", nil)
    |> put_resp_header("content-transfer-encoding", "binary")
    |> put_resp_header("content-disposition", ~s[attachment; filename="mypdf.pdf"])
    |> send_file(200, filename)
  end
end

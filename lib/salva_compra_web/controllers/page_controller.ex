defmodule SalvaCompraWeb.PageController do
  use SalvaCompraWeb, :controller
  import Number.Currency

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
          "carrinho" => carrinho,
          "parcela" => parcela
        }
      }) do
    data = SalvaCompra.Carrinho.Produtos.produtos()

    dias =
      case parcela do
        "1" ->
          "À VISTA"

        parcela ->
          divisor = String.to_integer(parcela)
          dividendo = String.to_integer(condicao)
          resto = Integer.mod(dividendo, divisor)
          resultado = Integer.floor_div(dividendo, divisor)

          Enum.map(1..divisor, fn n -> n * resultado end)
          |> Enum.to_list()
          |> List.update_at(-1, &(&1 + resto))
          |> Enum.join("/")
      end

    produtos =
      Enum.with_index(carrinho, 1)
      |> Enum.map(fn {produto, index} ->
        item = data[produto["id"]]

        %{
          nome: item.nome,
          preco: item.preco,
          qtd: produto["qtd"],
          total: item.total,
          ipi: item.ipi,
          produto: item.produto,
          descricao: item.descricao,
          embalagem: item.embalagem,
          e_altura: item.e_altura,
          e_largura: item.e_largura,
          e_comprimento: item.e_comprimento,
          ncm: item.ncm,
          peso: item.peso,
          index: Integer.to_string(index) |> String.pad_leading(2, "0")
        }
      end)

    total =
      Enum.reduce(produtos, 0, fn produto, acc -> produto.total + acc end)
      |> number_to_currency(
        unit: "R$",
        delimiter: " ",
        separator: ","
      )

    produtos =
      Enum.map(produtos, fn produto ->
        Map.replace!(
          produto,
          :total,
          number_to_currency(produto.total,
            unit: "R$",
            delimiter: " ",
            separator: ","
          )
        )
      end)

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
        total: total,
        dias: dias
      })

    conn
    |> send_resp(200, html)

    # {:ok, filename} = PdfGenerator.generate(html)
  end
end

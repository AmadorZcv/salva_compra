defmodule SalvaCompraWeb.Components do
  alias SalvaCompraWeb.OrcamentoView
  #  2076 - 897,53652
  # 291,886 * 2,67 = 1296.66438 é a altura inicial
  @page_height 2076
  # 76,536 × 2,67 Header individual
  @header_height 204.35112
  #  105,8  * 2,67 Footer
  @footer_height 282.486
  # 48.27 * 2,67
  @produto_header_height 128.8809
  # 65,28 * 2,67
  @valor_table_height 174.2976
  # 11,255 * 2,67
  @produto_height 30.05085
  # 54,025 * 2,67
  @info_header_height 144.24675
  # 11,255 * 2,67
  @info_item_small_height 30.05085
  # 19,509  * 2,67
  @info_item_medium_height 52.08903

  def divisor(height) do
    IO.puts(height)
    Phoenix.View.render(OrcamentoView, "divisor.html", %{height: height})
  end

  def header(id) do
    IO.inspect(id)

    qr_code =
      Integer.to_string(id)
      |> EQRCode.encode()
      |> EQRCode.png(width: 56)
      |> Base.encode64()

    Phoenix.View.render(OrcamentoView, "filial.html", %{
      ntp: Images64.logo_ntp(),
      salva: Images64.logo_salva(),
      qr_code: "data:image/jpeg;base64,#{qr_code}"
    })
  end

  def footer(user, nome, nome_completo) do
    Phoenix.View.render(OrcamentoView, "footer_page.html", %{
      user: user,
      nome: nome,
      nome_completo: nome_completo
    })
  end

  def table_header() do
    Phoenix.View.render(OrcamentoView, "table_header.html", %{})
  end

  def table_info_header() do
    Phoenix.View.render(OrcamentoView, "table_info_header.html", %{})
  end

  def produto(produto) do
    Phoenix.View.render(OrcamentoView, "produto.html", %{produto: produto})
  end

  def produto_info(produto) do
    Phoenix.View.render(OrcamentoView, "produto_info.html", %{produto: produto})
  end

  def valor_table(total) do
    Phoenix.View.render(OrcamentoView, "valor.html", %{total: total})
  end

  def new_page(user, nome, nome_completo, id) do
    header_html = header(id)
    footer_html = footer(user, nome, nome_completo)

    fn height ->
      {[divisor(height - @footer_height), footer_html, header_html],
       @page_height - @header_height}
    end
  end

  def produtos({height, new_page, html}, produtos) do
    IO.puts("Altura Inicial produtos #{height}")

    {produtos_html, height} =
      Enum.map_reduce(produtos, height, fn produto, height ->
        if height - @produto_height < @footer_height do
          table_header_html = table_header()
          produto_html = produto(produto)
          {new_page_html, height} = new_page.(height)

          IO.puts(
            "Produto #{produto.nome} altura #{height - @produto_header_height - @produto_height} Pagina quebrou"
          )

          {[new_page_html, table_header_html, produto_html],
           height - @produto_header_height - @produto_height}
        else
          IO.puts("Produto #{produto.nome} altura #{height - @produto_height}")
          {produto(produto), height - @produto_height}
        end
      end)

    {height, new_page, [html | produtos_html]}
  end

  def valor({height, new_page, html}, total) do
    {valor_html, height} =
      if height - @valor_table_height < @footer_height do
        {new_page_html, height} = new_page.(height)
        valor_html = valor_table(total)
        IO.puts("Valor #{total} altura #{height - @valor_table_height} Pagina quebrou")
        {[new_page_html, valor_html], height - @valor_table_height}
      else
        valor_html = valor_table(total)
        IO.puts("Valor #{total} altura #{height - @valor_table_height}")
        {[valor_html], height - @valor_table_height}
      end

    {height, new_page, [html | valor_html]}
  end

  def info_header({height, new_page, html}) do
    {info_header_html, height} =
      if height - @info_header_height < @footer_height do
        {new_page_html, height} = new_page.(height)
        info_header_html = table_info_header()
        IO.puts("Info header altura #{height - @info_header_height} Pagina quebrou")
        {[new_page_html, info_header_html], height - @info_header_height}
      else
        IO.puts("Info header altura #{height - @info_header_height}")
        info_header_html = table_info_header()
        {[info_header_html], height - @info_header_height}
      end

    {height, new_page, [html | info_header_html]}
  end

  def produtos_info({height, new_page, html}, produtos) do
    {produtos_html, height} =
      Enum.map_reduce(produtos, height, fn produto, height ->
        produto_info_height =
          if String.length(produto.produto) > 33 || String.length(produto.descricao) > 33 do
            @info_item_medium_height
          else
            @info_item_small_height
          end

        IO.puts("Produto #{produto.nome}")
        IO.puts(String.length(produto.produto))

        if height - produto_info_height < @footer_height do
          table_header_html = table_info_header()
          produto_html = produto_info(produto)
          {new_page_html, height} = new_page.(height)

          IO.puts(
            "Produto #{produto.nome} altura #{height - @info_header_height - produto_info_height} Pagina quebrou"
          )

          {[new_page_html, table_header_html, produto_html],
           height - @info_header_height - produto_info_height}
        else
          IO.puts("Produto #{produto.nome} altura #{height - produto_info_height}")
          {produto_info(produto), height - produto_info_height}
        end
      end)

    {height, new_page, [html | produtos_html]}
  end

  def build_page(produtos, height, user, nome, nome_completo, total, id) do
    new_page_fn = new_page(user, nome, nome_completo, id)

    {height, _, html} =
      {height, new_page_fn, {:safe, ""}}
      |> produtos(produtos)
      |> valor(total)
      |> info_header()
      |> produtos_info(produtos)

    IO.puts(height)

    [
      html,
      divisor(height - @footer_height),
      footer(user, nome, nome_completo)
    ]
  end

  # <%=  Enum.map(@produtos, fn produto ->  %>
  # <%= render(SalvaCompraWeb.OrcamentoView,"produto.html",%{produto: produto}) %>

  # <% end) %>
end

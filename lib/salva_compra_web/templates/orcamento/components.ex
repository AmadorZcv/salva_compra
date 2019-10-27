defmodule SalvaCompraWeb.Components do
  alias SalvaCompraWeb.OrcamentoView
  @page_height 785
  @header_height 30
  @footer_height 40
  @valor_table_height 40
  @produto_height 12.75
  def divisor(height) do
    Phoenix.View.render(OrcamentoView, "divisor.html", %{height: height})
  end

  def header() do
    Phoenix.View.render(OrcamentoView, "filial.html", %{
      ntp: Images64.logo_ntp(),
      salva: Images64.logo_salva()
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

  def produto(produto) do
    Phoenix.View.render(OrcamentoView, "produto.html", %{produto: produto})
  end

  def valor_table(total) do
    Phoenix.View.render(OrcamentoView, "valor.html", %{total: total})
  end

  def new_page(user, nome, nome_completo) do
    header_html = header()
    footer_html = footer(user, nome, nome_completo)

    fn height ->
      {[divisor(height - @footer_height), footer_html, header_html],
       @page_height - @header_height}
    end
  end

  def produtos({height, new_page, html}, produtos) do
    {produtos_html, height} =
      Enum.map_reduce(produtos, height, fn produto, height ->
        if height - @produto_height < @footer_height do
          table_header_html = table_header()
          produto_html = produto(produto)
          {new_page_html, height} = new_page.(height)
          {[new_page_html, table_header_html, produto_html], height}
        else
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
        {[new_page_html, valor_html], height}
      else
        valor_html = valor_table(total)
        {[valor_html], height - @valor_table_height}
      end

    {height, new_page, [html | valor_html]}
  end

  def build_page(produtos, height, user, nome, nome_completo, total) do
    new_page_fn = new_page(user, nome, nome_completo)

    {_, _, html} =
      {height, new_page_fn, {:safe, ""}}
      |> produtos(produtos)
      |> valor(total)

    html
  end

  # <%=  Enum.map(@produtos, fn produto ->  %>
  # <%= render(SalvaCompraWeb.OrcamentoView,"produto.html",%{produto: produto}) %>

  # <% end) %>
end

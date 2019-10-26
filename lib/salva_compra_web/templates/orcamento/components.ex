defmodule SalvaCompraWeb.Components do
  alias SalvaCompraWeb.OrcamentoView
  @page_height 785

  def produtos(produtos, height) do
    {html, _} =
      Enum.map_reduce(produtos, height, fn produto, height ->
        if height < 12.75 do
          {Phoenix.View.render(OrcamentoView, "table_header.html", %{}), @page_height}
        else
          {Phoenix.View.render(OrcamentoView, "produto.html", %{produto: produto}),
           height - 12.75}
        end
      end)

    html
  end

  # <%=  Enum.map(@produtos, fn produto ->  %>
  # <%= render(SalvaCompraWeb.OrcamentoView,"produto.html",%{produto: produto}) %>

  # <% end) %>
end

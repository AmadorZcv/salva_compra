defmodule SalvaCompraWeb.PageController do
  use SalvaCompraWeb, :controller

  def index(conn, _params) do
    render(conn, "old.html")
  end

  def print(conn, _params) do
    html = Phoenix.View.render_to_string(SalvaCompraWeb.PageView, "pdf.html", %{})
    {:ok, filename} = PdfGenerator.generate(html)

    conn
    |> put_resp_content_type("application/octet-stream", nil)
    |> put_resp_header("content-transfer-encoding", "binary")
    |> put_resp_header("content-disposition", ~s[attachment; filename="test.pdf"])
    |> send_file(200, filename)
  end
end

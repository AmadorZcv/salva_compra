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

  def print(conn, %{"usuario" => usuario_params}) do
    IO.inspect(usuario_params)

    html =
      Phoenix.View.render_to_string(SalvaCompraWeb.PageView, "new_pdf.html", %{
        conn: conn,
        ntp: Images64.logo_ntp(),
        salva: Images64.logo_salva()
      })

    # {:ok, filename} = PdfGenerator.generate(html)
    {:ok, filename} =
      PdfGenerator.generate(html,
        generator: :chrome,
        prefer_system_executable: true
      )

    conn
    |> put_resp_content_type("application/octet-stream", nil)
    |> put_resp_header("content-transfer-encoding", "binary")
    |> put_resp_header("content-disposition", ~s[attachment; filename="mypdf.pdf"])
    |> send_file(200, filename)
  end
end

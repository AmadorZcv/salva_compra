defmodule SalvaCompraWeb.Plugs.AdminPlug do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    case conn.assigns[:role] do
      0 -> unauthorized(conn)
      1 -> conn
      _ -> unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> send_resp(403, "Forbidden")
    |> halt()
  end
end

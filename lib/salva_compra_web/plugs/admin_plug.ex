defmodule SalvaCompraWeb.Plugs.AdminPlug do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    IO.puts("Aqui")
    IO.inspect(conn.assigns[:user_role])

    case conn.assigns[:user_role] do
      :user -> unauthorized(conn)
      :admin -> conn
      _ -> unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> send_resp(403, "Forbidden")
    |> halt()
  end
end

defmodule SalvaCompraWeb.Plugs.SecureCreatePlug do
  import Plug.Conn

  def init(default), do: default

  def check_token(token) do
    if token == "nOSuyCRZZgv5chvywDLpXhy4ADyURJwYgO0W8k5ZV2prmFF2yyiz6wSMW5y4SIOY" do
      true
    else
      false
    end
  end

  def call(conn, _default) do
    case Plug.Conn.get_req_header(conn, "create_token") do
      [token] ->
        String.trim(token)
        |> check_token()
        |> case do
          true ->
            conn

          false ->
            conn
            |> send_resp(401, "Unauthorized")
            |> halt()
        end

      _ ->
        conn
        |> send_resp(401, "Unauthorized")
        |> halt()
    end
  end
end

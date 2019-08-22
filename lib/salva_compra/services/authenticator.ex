defmodule SalvaCompra.Services.Authenticator do
  @seed "2TnkPGiuMpGPSOqrG"
  @secret "lpMeq7PV3T9EP8JTv6LrbmBLk5THsmyqCogoMNbDPmUASdQL+miWi8BQDuT0T8DT"

  def generate_token(id) do
    Phoenix.Token.sign(@secret, @seed, id, max_age: 86400)
  end

  def verify_token(token) do
    case Phoenix.Token.verify(@secret, @seed, token) do
      # 0 - user, 1 - professor
      {:ok, {id, type}} -> {:ok, token, id, type}
      error -> error
    end
  end

  def get_auth_token(conn) do
    case extract_token(conn) do
      {:ok, token} -> verify_token(token)
      error -> error
    end
  end

  # extrai o token do conn
  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [auth_header] ->
        # get_token_from_header(auth_header)
        {:ok, String.trim(auth_header)}

      _ ->
        {:error, :missing_auth_header}
    end

    case Plug.Conn.get_session(conn, :token) do
      nil ->
        {:error, :missing_auth_header}

      token ->
        {:ok, token.token}
    end
  end
end
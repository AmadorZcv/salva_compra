defmodule SalvaCompraWeb.Plugs.AuthenticatePlug do
  import Plug.Conn
  alias SalvaCompra.Auth
  alias SalvaCompra.Services.Authenticator
  def init(default), do: default

  def call(conn, _default) do
    case Authenticator.get_auth_token(conn) do
      # 0 - User
      {:ok, token, id, 0} ->
        case Auth.validate_user_token(id, token) do
          nil -> unauthorized(conn)
          user -> authorized_user(conn, user.id, :user)
        end

      # 1 - Admin
      {:ok, token, id, 1} ->
        case Auth.validate_user_token(id, token) do
          nil -> unauthorized(conn)
          user -> authorized_user(conn, user.id, :admin)
        end

      _ ->
        unauthorized(conn)
    end
  end

  # role :user, :professor
  defp authorized_user(conn, id, role) do
    conn
    |> assign(:user_role, role)
    |> assign(:user_id, id)
  end

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end
end

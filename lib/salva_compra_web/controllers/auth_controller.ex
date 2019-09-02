defmodule SalvaCompraWeb.AuthController do
  use SalvaCompraWeb, :controller
  alias SalvaCompra.{Auth, Accounts}

  def registrar(conn, %{"usuario" => usuario_params}) do
    with {:ok, usuario} <- Accounts.create_user(usuario_params) do
      conn
      |> put_status(:created)
      |> render("sign_up_success.json", %{id: usuario.id})
    end
  end

  def sign_in(conn, %{"login" => login, "password" => password}) do
    case Auth.sign_in(login, password) do
      {:ok, auth_token} ->
        user = Accounts.get_user!(auth_token.user_id)

        conn
        |> put_status(:ok)
        |> render("show.json", %{auth_token: auth_token, user: user})

      {:error, reason} ->
        conn
        |> send_resp(401, reason)
    end
  end

  def sign_out(conn, _) do
    case Auth.sign_out(conn) do
      {:error, reason} -> conn |> send_resp(400, reason)
      {:ok, _} -> conn |> send_resp(204, "")
    end
  end
end

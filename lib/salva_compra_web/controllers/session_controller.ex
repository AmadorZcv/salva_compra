defmodule SalvaCompraWeb.SessionController do
  use SalvaCompraWeb, :controller
  alias SalvaCompra.{Auth}

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"login" => login, "password" => password}}) do
    case Auth.sign_in(login, password) do
      {:ok, auth_token} ->
        conn
        |> put_session(:token, auth_token)
        |> put_session(:login, login)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _) do
    case Auth.sign_out(conn) do
      {:error, _} -> conn |> redirect(to: Routes.page_path(conn, :index))
      {:ok, _} -> conn |> clear_session |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end

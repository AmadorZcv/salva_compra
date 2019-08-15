defmodule SalvaCompraWeb.OrcamentoController do
  use SalvaCompraWeb, :controller

  alias SalvaCompra.Orcamentos
  alias SalvaCompra.Orcamentos.Orcamento

  action_fallback SalvaCompraWeb.FallbackController

  def index(conn, _params) do
    orcamentos = Orcamentos.list_orcamentos()
    render(conn, "index.json", orcamentos: orcamentos)
  end

  def create(conn, %{"orcamento" => orcamento_params}) do
    with {:ok, %Orcamento{} = orcamento} <- Orcamentos.create_orcamento(orcamento_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.orcamento_path(conn, :show, orcamento))
      |> render("show.json", orcamento: orcamento)
    end
  end

  def show(conn, %{"id" => id}) do
    orcamento = Orcamentos.get_orcamento!(id)
    render(conn, "show.json", orcamento: orcamento)
  end

  def update(conn, %{"id" => id, "orcamento" => orcamento_params}) do
    orcamento = Orcamentos.get_orcamento!(id)

    with {:ok, %Orcamento{} = orcamento} <- Orcamentos.update_orcamento(orcamento, orcamento_params) do
      render(conn, "show.json", orcamento: orcamento)
    end
  end

  def delete(conn, %{"id" => id}) do
    orcamento = Orcamentos.get_orcamento!(id)

    with {:ok, %Orcamento{}} <- Orcamentos.delete_orcamento(orcamento) do
      send_resp(conn, :no_content, "")
    end
  end
end

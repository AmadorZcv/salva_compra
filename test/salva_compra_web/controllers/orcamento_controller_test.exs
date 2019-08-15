defmodule SalvaCompraWeb.OrcamentoControllerTest do
  use SalvaCompraWeb.ConnCase

  alias SalvaCompra.Orcamentos
  alias SalvaCompra.Orcamentos.Orcamento

  @create_attrs %{
    cidade: "some cidade",
    condicao: "some condicao",
    cpf: "some cpf",
    criacao: "some criacao",
    email: "some email",
    nome: "some nome",
    nome_completo: "some nome_completo",
    parcela: 42,
    ramo: "some ramo",
    telefone: "some telefone",
    uf: "some uf",
    validade: "some validade"
  }
  @update_attrs %{
    cidade: "some updated cidade",
    condicao: "some updated condicao",
    cpf: "some updated cpf",
    criacao: "some updated criacao",
    email: "some updated email",
    nome: "some updated nome",
    nome_completo: "some updated nome_completo",
    parcela: 43,
    ramo: "some updated ramo",
    telefone: "some updated telefone",
    uf: "some updated uf",
    validade: "some updated validade"
  }
  @invalid_attrs %{cidade: nil, condicao: nil, cpf: nil, criacao: nil, email: nil, nome: nil, nome_completo: nil, parcela: nil, ramo: nil, telefone: nil, uf: nil, validade: nil}

  def fixture(:orcamento) do
    {:ok, orcamento} = Orcamentos.create_orcamento(@create_attrs)
    orcamento
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all orcamentos", %{conn: conn} do
      conn = get(conn, Routes.orcamento_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create orcamento" do
    test "renders orcamento when data is valid", %{conn: conn} do
      conn = post(conn, Routes.orcamento_path(conn, :create), orcamento: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.orcamento_path(conn, :show, id))

      assert %{
               "id" => id,
               "cidade" => "some cidade",
               "condicao" => "some condicao",
               "cpf" => "some cpf",
               "criacao" => "some criacao",
               "email" => "some email",
               "nome" => "some nome",
               "nome_completo" => "some nome_completo",
               "parcela" => 42,
               "ramo" => "some ramo",
               "telefone" => "some telefone",
               "uf" => "some uf",
               "validade" => "some validade"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.orcamento_path(conn, :create), orcamento: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update orcamento" do
    setup [:create_orcamento]

    test "renders orcamento when data is valid", %{conn: conn, orcamento: %Orcamento{id: id} = orcamento} do
      conn = put(conn, Routes.orcamento_path(conn, :update, orcamento), orcamento: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.orcamento_path(conn, :show, id))

      assert %{
               "id" => id,
               "cidade" => "some updated cidade",
               "condicao" => "some updated condicao",
               "cpf" => "some updated cpf",
               "criacao" => "some updated criacao",
               "email" => "some updated email",
               "nome" => "some updated nome",
               "nome_completo" => "some updated nome_completo",
               "parcela" => 43,
               "ramo" => "some updated ramo",
               "telefone" => "some updated telefone",
               "uf" => "some updated uf",
               "validade" => "some updated validade"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, orcamento: orcamento} do
      conn = put(conn, Routes.orcamento_path(conn, :update, orcamento), orcamento: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete orcamento" do
    setup [:create_orcamento]

    test "deletes chosen orcamento", %{conn: conn, orcamento: orcamento} do
      conn = delete(conn, Routes.orcamento_path(conn, :delete, orcamento))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.orcamento_path(conn, :show, orcamento))
      end
    end
  end

  defp create_orcamento(_) do
    orcamento = fixture(:orcamento)
    {:ok, orcamento: orcamento}
  end
end

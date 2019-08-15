defmodule SalvaCompra.OrcamentosTest do
  use SalvaCompra.DataCase

  alias SalvaCompra.Orcamentos

  describe "orcamentos" do
    alias SalvaCompra.Orcamentos.Orcamento

    @valid_attrs %{cidade: "some cidade", condicao: "some condicao", cpf: "some cpf", criacao: "some criacao", email: "some email", nome: "some nome", nome_completo: "some nome_completo", parcela: 42, ramo: "some ramo", telefone: "some telefone", uf: "some uf", validade: "some validade"}
    @update_attrs %{cidade: "some updated cidade", condicao: "some updated condicao", cpf: "some updated cpf", criacao: "some updated criacao", email: "some updated email", nome: "some updated nome", nome_completo: "some updated nome_completo", parcela: 43, ramo: "some updated ramo", telefone: "some updated telefone", uf: "some updated uf", validade: "some updated validade"}
    @invalid_attrs %{cidade: nil, condicao: nil, cpf: nil, criacao: nil, email: nil, nome: nil, nome_completo: nil, parcela: nil, ramo: nil, telefone: nil, uf: nil, validade: nil}

    def orcamento_fixture(attrs \\ %{}) do
      {:ok, orcamento} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orcamentos.create_orcamento()

      orcamento
    end

    test "list_orcamentos/0 returns all orcamentos" do
      orcamento = orcamento_fixture()
      assert Orcamentos.list_orcamentos() == [orcamento]
    end

    test "get_orcamento!/1 returns the orcamento with given id" do
      orcamento = orcamento_fixture()
      assert Orcamentos.get_orcamento!(orcamento.id) == orcamento
    end

    test "create_orcamento/1 with valid data creates a orcamento" do
      assert {:ok, %Orcamento{} = orcamento} = Orcamentos.create_orcamento(@valid_attrs)
      assert orcamento.cidade == "some cidade"
      assert orcamento.condicao == "some condicao"
      assert orcamento.cpf == "some cpf"
      assert orcamento.criacao == "some criacao"
      assert orcamento.email == "some email"
      assert orcamento.nome == "some nome"
      assert orcamento.nome_completo == "some nome_completo"
      assert orcamento.parcela == 42
      assert orcamento.ramo == "some ramo"
      assert orcamento.telefone == "some telefone"
      assert orcamento.uf == "some uf"
      assert orcamento.validade == "some validade"
    end

    test "create_orcamento/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orcamentos.create_orcamento(@invalid_attrs)
    end

    test "update_orcamento/2 with valid data updates the orcamento" do
      orcamento = orcamento_fixture()
      assert {:ok, %Orcamento{} = orcamento} = Orcamentos.update_orcamento(orcamento, @update_attrs)
      assert orcamento.cidade == "some updated cidade"
      assert orcamento.condicao == "some updated condicao"
      assert orcamento.cpf == "some updated cpf"
      assert orcamento.criacao == "some updated criacao"
      assert orcamento.email == "some updated email"
      assert orcamento.nome == "some updated nome"
      assert orcamento.nome_completo == "some updated nome_completo"
      assert orcamento.parcela == 43
      assert orcamento.ramo == "some updated ramo"
      assert orcamento.telefone == "some updated telefone"
      assert orcamento.uf == "some updated uf"
      assert orcamento.validade == "some updated validade"
    end

    test "update_orcamento/2 with invalid data returns error changeset" do
      orcamento = orcamento_fixture()
      assert {:error, %Ecto.Changeset{}} = Orcamentos.update_orcamento(orcamento, @invalid_attrs)
      assert orcamento == Orcamentos.get_orcamento!(orcamento.id)
    end

    test "delete_orcamento/1 deletes the orcamento" do
      orcamento = orcamento_fixture()
      assert {:ok, %Orcamento{}} = Orcamentos.delete_orcamento(orcamento)
      assert_raise Ecto.NoResultsError, fn -> Orcamentos.get_orcamento!(orcamento.id) end
    end

    test "change_orcamento/1 returns a orcamento changeset" do
      orcamento = orcamento_fixture()
      assert %Ecto.Changeset{} = Orcamentos.change_orcamento(orcamento)
    end
  end
end

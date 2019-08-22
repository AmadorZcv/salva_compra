defmodule SalvaCompra.AccountsTest do
  use SalvaCompra.DataCase

  alias SalvaCompra.Accounts

  describe "users" do
    alias SalvaCompra.Accounts.User

    @valid_attrs %{email: "some email", filial_id: 42, funcionario_id: 42, login: "some login", nome: "some nome", password_hash: "some password_hash", telefone: "some telefone"}
    @update_attrs %{email: "some updated email", filial_id: 43, funcionario_id: 43, login: "some updated login", nome: "some updated nome", password_hash: "some updated password_hash", telefone: "some updated telefone"}
    @invalid_attrs %{email: nil, filial_id: nil, funcionario_id: nil, login: nil, nome: nil, password_hash: nil, telefone: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.filial_id == 42
      assert user.funcionario_id == 42
      assert user.login == "some login"
      assert user.nome == "some nome"
      assert user.password_hash == "some password_hash"
      assert user.telefone == "some telefone"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.filial_id == 43
      assert user.funcionario_id == 43
      assert user.login == "some updated login"
      assert user.nome == "some updated nome"
      assert user.password_hash == "some updated password_hash"
      assert user.telefone == "some updated telefone"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end

defmodule SalvaCompra.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nome, :string
      add :telefone, :string
      add :filial_id, :integer
      add :funcionario_id, :integer
      add :password_hash, :string
      add :login, :string
      add :email, :string

      timestamps()
    end

  end
end

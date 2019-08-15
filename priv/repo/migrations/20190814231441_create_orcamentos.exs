defmodule SalvaCompra.Repo.Migrations.CreateOrcamentos do
  use Ecto.Migration

  def change do
    create table(:orcamentos) do
      add :criacao, :string
      add :validade, :string
      add :condicao, :string
      add :telefone, :string
      add :cidade, :string
      add :nome, :string
      add :nome_completo, :string
      add :uf, :string
      add :cpf, :string
      add :email, :string
      add :ramo, :string
      add :parcela, :integer

      timestamps()
    end

  end
end

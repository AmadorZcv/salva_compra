defmodule SalvaCompra.Repo.Migrations.CreateOrcamentoProdutos do
  use Ecto.Migration

  def change do
    create table(:orcamento_produtos) do
      add :produto_id, :integer
      add :preco, :integer
      add :ipi, :integer
      add :ipic, :integer
      add :total, :integer
      add :orcamento_id, references(:orcamentos, on_delete: :nothing)

      timestamps()
    end

    create index(:orcamento_produtos, [:orcamento_id])
  end
end

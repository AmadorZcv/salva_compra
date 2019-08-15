defmodule SalvaCompra.Repo.Migrations.AddQtd do
  use Ecto.Migration

  def change do
    alter table(:orcamento_produtos) do
      add :qtd, :integer
    end
  end
end

defmodule SalvaCompra.Repo.Migrations.AddObsOrcamento do
  use Ecto.Migration

  def change do
    alter table(:orcamentos) do
      add :obs, :string, default: "Sem observações"
    end
  end
end

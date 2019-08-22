defmodule SalvaCompra.Repo.Migrations.AddUserOrcamento do
  use Ecto.Migration

  def change do
    alter table(:orcamentos) do
      add :day_id, :integer
      add :title, :string
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end

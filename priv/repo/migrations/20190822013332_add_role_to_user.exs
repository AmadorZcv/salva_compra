defmodule SalvaCompra.Repo.Migrations.AddRoleToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :integer
    end
  end
end

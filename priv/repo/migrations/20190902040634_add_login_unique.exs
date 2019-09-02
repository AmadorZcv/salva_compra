defmodule SalvaCompra.Repo.Migrations.AddLoginUnique do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:login])
  end
end

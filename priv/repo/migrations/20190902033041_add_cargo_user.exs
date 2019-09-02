defmodule SalvaCompra.Repo.Migrations.AddCargoUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :cargo, :string
    end
  end
end

defmodule SalvaCompra.Repo.Migrations.CreateAuthTokens do
  use Ecto.Migration

  def change do
    create table(:auth_tokens) do
      add :revoked, :boolean, default: false, null: false
      add :revoked_at, :utc_datetime
      add :token, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:auth_tokens, [:user_id])
  end
end

defmodule SalvaCompra.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SalvaCompra.Accounts.AuthToken
  alias SalvaCompra.Orcamentos.Orcamento

  schema "users" do
    field :email, :string
    field :filial_id, :integer
    field :funcionario_id, :integer
    field :login, :string
    field :nome, :string
    field :cargo, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :telefone, :string
    field :role, :integer
    has_many :auth_tokens, AuthToken
    has_many :orcamentos, Orcamento
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :nome,
      :telefone,
      :filial_id,
      :funcionario_id,
      :password,
      :login,
      :email,
      :role,
      :cargo
    ])
    |> validate_required([
      :nome,
      :telefone,
      :filial_id,
      :funcionario_id,
      :login,
      :email,
      :role,
      :cargo
    ])
    |> put_password_hash()
    |> unique_constraint(:login)
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end

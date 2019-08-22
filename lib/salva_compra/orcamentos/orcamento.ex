defmodule SalvaCompra.Orcamentos.Orcamento do
  use Ecto.Schema
  import Ecto.Changeset
  alias SalvaCompra.Orcamentos.OrcamentoProduto
  alias SalvaCompra.Accounts.User

  schema "orcamentos" do
    field :cidade, :string
    field :condicao, :string
    field :cpf, :string
    field :criacao, :string
    field :email, :string
    field :nome, :string
    field :nome_completo, :string
    field :parcela, :integer
    field :ramo, :string
    field :telefone, :string
    field :uf, :string
    field :validade, :string
    field :day_id, :integer
    field :title, :string
    belongs_to :user, User
    has_many :produtos, OrcamentoProduto
    timestamps()
  end

  @doc false
  def changeset(orcamento, attrs) do
    orcamento
    |> cast(attrs, [
      :criacao,
      :validade,
      :condicao,
      :telefone,
      :cidade,
      :nome,
      :nome_completo,
      :uf,
      :cpf,
      :email,
      :ramo,
      :parcela,
      :user_id,
      :day_id,
      :title
    ])
    |> validate_required([
      :criacao,
      :validade,
      :condicao,
      :telefone,
      :cidade,
      :nome,
      :nome_completo,
      :uf,
      :cpf,
      :email,
      :ramo,
      :parcela,
      :day_id,
      :title
    ])
    |> cast_assoc(:produtos, required: true)
  end
end

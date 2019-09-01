defmodule SalvaCompra.Orcamentos.OrcamentoProduto do
  use Ecto.Schema
  import Ecto.Changeset
  alias SalvaCompra.Orcamentos.Orcamento

  schema "orcamento_produtos" do
    field :ipi, :integer
    field :ipic, :integer
    field :preco, :integer
    field :produto_id, :integer
    field :total, :integer
    field :qtd, :integer
    belongs_to :orcamento, Orcamento

    timestamps()
  end

  @doc false
  def changeset(orcamento_produto, attrs) do
    orcamento_produto
    |> cast(attrs, [:produto_id, :preco, :ipi, :ipic, :total, :orcamento_id, :qtd])
    |> validate_required([:produto_id, :preco, :ipi, :ipic, :total, :qtd])
  end
end

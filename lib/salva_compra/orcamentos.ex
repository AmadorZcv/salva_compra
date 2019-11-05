defmodule SalvaCompra.Orcamentos do
  @moduledoc """
  The Orcamentos context.
  """
  use Timex
  import Ecto.Query, warn: false
  alias SalvaCompra.Repo
  alias SalvaCompra.Orcamentos.Orcamento
  alias SalvaCompra.Accounts
  alias SalvaCompra.Format.Dinheiro

  @doc """
  Returns the list of orcamentos.

  ## Examples

      iex> list_orcamentos()
      [%Orcamento{}, ...]

  """
  def list_orcamentos do
    Repo.all(Orcamento)
  end

  def list_orcamentos(user_id) do
    Orcamento
    |> where([o], o.user_id == ^user_id)
    |> Repo.all()
    |> Repo.preload(:produtos)
  end

  @doc """
  Gets a single orcamento.

  Raises `Ecto.NoResultsError` if the Orcamento does not exist.

  ## Examples

      iex> get_orcamento!(123)
      %Orcamento{}

      iex> get_orcamento!(456)
      ** (Ecto.NoResultsError)

  """
  def get_orcamento!(id), do: Repo.get!(Orcamento, id) |> Repo.preload(:produtos)

  @doc """
  Creates a orcamento.

  ## Examples

      iex> create_orcamento(%{field: value})
      {:ok, %Orcamento{}}

      iex> create_orcamento(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_orcamento(attrs) do
    user = Accounts.get_user!(attrs.user_id)

    day =
      Timex.parse!(attrs.criacao, "{0D}/{0M}/{YYYY}")
      |> Timex.format!("{YYYY}{0M}{0D}")

    filial =
      Integer.to_string(user.filial_id)
      |> String.pad_leading(3, "0")

    funcionario =
      Integer.to_string(user.funcionario_id)
      |> String.pad_leading(3, "0")

    day_id = get_last_day_id(attrs) + 1

    orcamento =
      Map.put(attrs, :day_id, day_id)
      |> Map.put(:title, "#{day}#{filial}#{funcionario}-#{day_id}")

    IO.inspect(orcamento)

    %Orcamento{}
    |> Orcamento.changeset(orcamento)
    |> Repo.insert()
  end

  def get_last_day_id(orcamento) do
    case Repo.all(
           from u in Orcamento,
             where: u.user_id == ^orcamento.user_id,
             where: u.criacao == ^orcamento.criacao,
             limit: 1,
             order_by: [desc: u.day_id]
         ) do
      [last_orcamento] ->
        last_orcamento.day_id

      [] ->
        0
    end
  end

  @doc """
  Updates a orcamento.

  ## Examples

      iex> update_orcamento(orcamento, %{field: new_value})
      {:ok, %Orcamento{}}

      iex> update_orcamento(orcamento, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_orcamento(%Orcamento{} = orcamento, attrs) do
    orcamento
    |> Orcamento.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Orcamento.

  ## Examples

      iex> delete_orcamento(orcamento)
      {:ok, %Orcamento{}}

      iex> delete_orcamento(orcamento)
      {:error, %Ecto.Changeset{}}

  """
  def delete_orcamento(%Orcamento{} = orcamento) do
    Repo.delete(orcamento)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking orcamento changes.

  ## Examples

      iex> change_orcamento(orcamento)
      %Ecto.Changeset{source: %Orcamento{}}

  """
  def change_orcamento(%Orcamento{} = orcamento) do
    Orcamento.changeset(orcamento, %{})
  end

  def orcamento_to_html(orcamento, conn) do
    user = Accounts.get_user!(orcamento.user_id)
    data = SalvaCompra.Carrinho.Produtos.produtos()

    dias =
      case orcamento.parcela do
        1 ->
          "À VISTA"

        parcela ->
          divisor = parcela
          dividendo = String.to_integer(orcamento.condicao)
          resto = Integer.mod(dividendo, divisor)
          resultado = Integer.floor_div(dividendo, divisor)

          Enum.map(1..divisor, fn n -> n * resultado end)
          |> Enum.to_list()
          |> List.update_at(-1, &(&1 + resto))
          |> Enum.join("/")
      end

    produtos =
      Enum.with_index(orcamento.produtos, 1)
      |> Enum.map(fn {produto, index} ->
        item = data[Integer.to_string(produto.produto_id)]
        ipic = Integer.floor_div(produto.preco * produto.ipi, 100)
        total = produto.preco + ipic

        %{
          nome: item.nome,
          preco: Dinheiro.format_to_display(produto.preco),
          qtd: produto.qtd,
          total: total,
          ipi: produto.ipi,
          produto: item.produto,
          descricao: item.descricao,
          embalagem: item.embalagem,
          e_altura: item.e_altura,
          e_largura: item.e_largura,
          e_comprimento: item.e_comprimento,
          ncm: item.ncm,
          peso: item.peso,
          index: Integer.to_string(index) |> String.pad_leading(2, "0"),
          color:
            if rem(index, 2) == 0 do
              "rgb(234, 234, 234)"
            else
              "#fff"
            end
        }
      end)

    total =
      Enum.reduce(produtos, 0, fn produto, acc -> produto.total * produto.qtd + acc end)
      |> Dinheiro.format_to_display()

    produtos =
      Enum.map(produtos, fn produto ->
        Map.replace!(
          produto,
          :total,
          Dinheiro.format_to_display(produto.total)
        )
      end)

    Phoenix.View.render_to_string(SalvaCompraWeb.PageView, "new_pdf.html", %{
      conn: conn,
      ntp: Images64.logo_ntp(),
      salva: Images64.logo_salva(),
      criacao: orcamento.criacao,
      validade: orcamento.validade,
      condicao: orcamento.condicao,
      telefone: orcamento.telefone,
      cidade: orcamento.cidade,
      nome: orcamento.nome,
      nome_completo: orcamento.nome_completo,
      uf: orcamento.uf,
      cpf: orcamento.cpf,
      email: orcamento.email,
      ramo: orcamento.ramo,
      produtos: produtos,
      total: total,
      dias: dias,
      user: user,
      title: orcamento.title,
      orcamento: orcamento
    })
  end
end

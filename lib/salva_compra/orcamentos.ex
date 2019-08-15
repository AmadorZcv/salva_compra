defmodule SalvaCompra.Orcamentos do
  @moduledoc """
  The Orcamentos context.
  """

  import Ecto.Query, warn: false
  alias SalvaCompra.Repo

  alias SalvaCompra.Orcamentos.Orcamento

  @doc """
  Returns the list of orcamentos.

  ## Examples

      iex> list_orcamentos()
      [%Orcamento{}, ...]

  """
  def list_orcamentos do
    Repo.all(Orcamento)
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
  def get_orcamento!(id), do: Repo.get!(Orcamento, id)

  @doc """
  Creates a orcamento.

  ## Examples

      iex> create_orcamento(%{field: value})
      {:ok, %Orcamento{}}

      iex> create_orcamento(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_orcamento(attrs \\ %{}) do
    %Orcamento{}
    |> Orcamento.changeset(attrs)
    |> Repo.insert()
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
end

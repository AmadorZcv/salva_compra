defmodule SalvaCompraWeb.AuthView do
  use SalvaCompraWeb, :view

  def render("sign_up_success.json", %{id: id}) do
    %{
      status: :ok,
      id: id,
      message: """
      Registrado com sucesso.
      """
    }
  end

  def render("show.json", %{:auth_token => auth_token, :user => user}) do
    filial =
      Integer.to_string(user.filial_id)
      |> String.pad_leading(3, "0")

    funcionario =
      Integer.to_string(user.funcionario_id)
      |> String.pad_leading(3, "0")

    %{
      data: %{
        token: auth_token.token,
        nome: user.nome,
        cargo: user.cargo,
        filialId: filial,
        funcionarioId: funcionario
      }
    }
  end
end

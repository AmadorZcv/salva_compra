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
    %{data: %{token: auth_token.token, nome: user.nome, cargo: user.cargo}}
  end
end

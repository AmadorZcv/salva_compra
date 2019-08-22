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

  def render("show.json", auth_token) do
    %{data: %{token: auth_token.token}}
  end
end

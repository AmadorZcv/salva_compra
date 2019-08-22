defmodule SalvaCompra.Auth do
  import Ecto.Query, warn: false
  alias SalvaCompra.Services.Authenticator
  alias SalvaCompra.Repo
  alias SalvaCompra.Accounts.{User, AuthToken}

  def validate_user_token(id, token) do
    from(
      u in User,
      join: t in AuthToken,
      where: u.id == ^id and t.token == ^token and t.revoked == false
    )
    |> Repo.one()
  end

  def sign_in(login, password) do
    case Bcrypt.check_pass(Repo.get_by(User, login: login), password) do
      {:ok, user} ->
        token = Authenticator.generate_token({user.id, user.role})
        Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))

      err ->
        err
    end
  end

  def sign_out(conn) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token, _id, _} ->
        case Repo.get_by(AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end

      error ->
        error
    end
  end
end

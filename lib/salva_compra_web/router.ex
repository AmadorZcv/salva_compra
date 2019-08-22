defmodule SalvaCompraWeb.Router do
  use SalvaCompraWeb, :router

  pipeline :authenticate do
    plug SalvaCompraWeb.Plugs.AuthenticatePlug
  end

  pipeline :admin do
    plug SalvaCompraWeb.Plugs.AdminPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SalvaCompraWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/pdf", PageController, :pdf
    get "/download", PageController, :print
    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", SalvaCompraWeb do
    pipe_through :browser
    pipe_through [:authenticate, :admin]
    resources "/users", UserController, only: [:new, :create, :delete, :edit, :update]
  end

  scope "/auth", SalvaCompraWeb do
    pipe_through :api

    post "/registrar", AuthController, :registrar
    post "/sign_in", AuthController, :sign_in
    delete "/sign_out", AuthController, :sign_out
  end

  # Other scopes may use custom stacks.
  scope "/api", SalvaCompraWeb do
    pipe_through :api
    pipe_through :authenticate
    post "/orcamento", OrcamentoController, :create
    post "/pdf", PageController, :print
    get "/orcamento/:id", OrcamentoController, :show
  end
end

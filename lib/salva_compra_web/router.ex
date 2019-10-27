defmodule SalvaCompraWeb.Router do
  use SalvaCompraWeb, :router

  pipeline :authenticate do
    plug SalvaCompraWeb.Plugs.AuthenticatePlug
  end

  pipeline :admin do
    plug SalvaCompraWeb.Plugs.AdminPlug
  end

  pipeline :create_secure do
    plug SalvaCompraWeb.Plugs.SecureCreatePlug
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
    get "/orcamento/:id", PageController, :show
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", SalvaCompraWeb do
    pipe_through :browser
    pipe_through [:authenticate, :admin]
    resources "/users", UserController, only: [:create, :delete, :edit, :update, :new, :show]
  end

  scope "/auth", SalvaCompraWeb do
    pipe_through :api

    post "/registrar", AuthController, :registrar
    post "/sign_in", AuthController, :sign_in
    delete "/sign_out", AuthController, :sign_out
  end

  scope "/create_secure", SalvaCompraWeb do
    pipe_through :api
    pipe_through :create_secure
    post "/users", UserController, :create_secure
  end

  # Other scopes may use custom stacks.
  scope "/api", SalvaCompraWeb do
    pipe_through :api

    pipe_through :authenticate
    post "/orcamento", OrcamentoController, :create
    post "/pdf", PageController, :print
    get "/orcamento/:id", OrcamentoController, :show
  end

  scope("/config", SalvaCompraWeb) do
    get "/produtos", ConfigController, :list_produtos
  end
end

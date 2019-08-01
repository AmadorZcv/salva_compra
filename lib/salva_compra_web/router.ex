defmodule SalvaCompraWeb.Router do
  use SalvaCompraWeb, :router

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
    get "/pdf", PageController, :print
  end

  # Other scopes may use custom stacks.
  # scope "/api", SalvaCompraWeb do
  #   pipe_through :api
  # end
end

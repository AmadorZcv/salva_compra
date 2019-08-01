# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :salva_compra,
  ecto_repos: [SalvaCompra.Repo]

# Configures the endpoint
config :salva_compra, SalvaCompraWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jJOy7UaiiQdjmioU5G1GXGLKZo+oOzvA9LsdguOC9Oi+FBO+8K3clViJlXVjBsBR",
  render_errors: [view: SalvaCompraWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SalvaCompra.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :pdf_generator,
  raise_on_missing_wkhtmltopdf_binary: false,
  # <-- make sure you installed node/puppeteer
  use_chrome: true,
  prefer_system_executable: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

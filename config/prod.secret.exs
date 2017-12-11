use Mix.Config


config :elixir_messenger_bot, ElixirMessengerBotWeb.Endpoint, secret_key_base: System.get_env("SECRET_KEY_BASE")
config :elixir_messenger_bot, ElixirMessengerBot.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 15

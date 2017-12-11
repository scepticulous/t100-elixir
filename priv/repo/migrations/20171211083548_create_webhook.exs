defmodule ElixirMessengerBot.Repo.Migrations.CreateWebhook do
  use Ecto.Migration

  def change do
    create table(:webhook) do

      timestamps()
    end

  end
end

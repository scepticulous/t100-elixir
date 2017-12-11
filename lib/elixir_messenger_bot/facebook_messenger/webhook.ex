defmodule ElixirMessengerBot.FacebookMessenger.Webhook do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirMessengerBot.FacebookMessenger.Webhook


  schema "webhook" do

    timestamps()
  end

  @doc false
  def changeset(%Webhook{} = webhook, attrs) do
    webhook
    |> cast(attrs, [])
    |> validate_required([])
  end
end

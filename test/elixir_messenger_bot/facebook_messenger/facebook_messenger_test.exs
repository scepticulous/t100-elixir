defmodule ElixirMessengerBot.FacebookMessengerTest do
  use ElixirMessengerBot.DataCase

  alias ElixirMessengerBot.FacebookMessenger

  describe "webhook" do
    alias ElixirMessengerBot.FacebookMessenger.Webhook

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def webhook_fixture(attrs \\ %{}) do
      {:ok, webhook} =
        attrs
        |> Enum.into(@valid_attrs)
        |> FacebookMessenger.create_webhook()

      webhook
    end

    test "list_webhook/0 returns all webhook" do
      webhook = webhook_fixture()
      assert FacebookMessenger.list_webhook() == [webhook]
    end

    test "get_webhook!/1 returns the webhook with given id" do
      webhook = webhook_fixture()
      assert FacebookMessenger.get_webhook!(webhook.id) == webhook
    end

    test "create_webhook/1 with valid data creates a webhook" do
      assert {:ok, %Webhook{} = webhook} = FacebookMessenger.create_webhook(@valid_attrs)
    end

    test "create_webhook/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FacebookMessenger.create_webhook(@invalid_attrs)
    end

    test "update_webhook/2 with valid data updates the webhook" do
      webhook = webhook_fixture()
      assert {:ok, webhook} = FacebookMessenger.update_webhook(webhook, @update_attrs)
      assert %Webhook{} = webhook
    end

    test "update_webhook/2 with invalid data returns error changeset" do
      webhook = webhook_fixture()
      assert {:error, %Ecto.Changeset{}} = FacebookMessenger.update_webhook(webhook, @invalid_attrs)
      assert webhook == FacebookMessenger.get_webhook!(webhook.id)
    end

    test "delete_webhook/1 deletes the webhook" do
      webhook = webhook_fixture()
      assert {:ok, %Webhook{}} = FacebookMessenger.delete_webhook(webhook)
      assert_raise Ecto.NoResultsError, fn -> FacebookMessenger.get_webhook!(webhook.id) end
    end

    test "change_webhook/1 returns a webhook changeset" do
      webhook = webhook_fixture()
      assert %Ecto.Changeset{} = FacebookMessenger.change_webhook(webhook)
    end
  end
end

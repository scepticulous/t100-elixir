defmodule ElixirMessengerBotWeb.WebhookControllerTest do
  use ElixirMessengerBotWeb.ConnCase

  alias ElixirMessengerBot.FacebookMessenger
  alias ElixirMessengerBot.FacebookMessenger.Webhook

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:webhook) do
    {:ok, webhook} = FacebookMessenger.create_webhook(@create_attrs)
    webhook
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all webhook", %{conn: conn} do
      conn = get conn, webhook_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create webhook" do
    test "renders webhook when data is valid", %{conn: conn} do
      conn = post conn, webhook_path(conn, :create), webhook: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, webhook_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, webhook_path(conn, :create), webhook: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update webhook" do
    setup [:create_webhook]

    test "renders webhook when data is valid", %{conn: conn, webhook: %Webhook{id: id} = webhook} do
      conn = put conn, webhook_path(conn, :update, webhook), webhook: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, webhook_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, webhook: webhook} do
      conn = put conn, webhook_path(conn, :update, webhook), webhook: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete webhook" do
    setup [:create_webhook]

    test "deletes chosen webhook", %{conn: conn, webhook: webhook} do
      conn = delete conn, webhook_path(conn, :delete, webhook)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, webhook_path(conn, :show, webhook)
      end
    end
  end

  defp create_webhook(_) do
    webhook = fixture(:webhook)
    {:ok, webhook: webhook}
  end
end

defmodule ElixirMessengerBotWeb.WebhookController do
  use ElixirMessengerBotWeb, :controller

  alias ElixirMessengerBot.FacebookMessenger
  alias ElixirMessengerBot.FacebookMessenger.Webhook

  action_fallback ElixirMessengerBotWeb.FallbackController

  def callback(conn, params) do
    IO.puts "------ params --------"
    IO.inspect(params)
    IO.puts "------ end of params --------"

    data =  %{"hub.challenge" => params["hub.challenge"], "hub.mode" => params["hub.mode"],
     "hub.verify_token" => params["hub.verify_token"]}

    IO.inspect(data)
    render(conn, "callback.json", data)
  end

  # def create(conn, %{"webhook" => webhook_params}) do
  #   with {:ok, %Webhook{} = webhook} <- FacebookMessenger.create_webhook(webhook_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", webhook_path(conn, :show, webhook))
  #     |> render("show.json", webhook: webhook)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   webhook = FacebookMessenger.get_webhook!(id)
  #   render(conn, "show.json", webhook: webhook)
  # end

  # def update(conn, %{"id" => id, "webhook" => webhook_params}) do
  #   webhook = FacebookMessenger.get_webhook!(id)

  #   with {:ok, %Webhook{} = webhook} <- FacebookMessenger.update_webhook(webhook, webhook_params) do
  #     render(conn, "show.json", webhook: webhook)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   webhook = FacebookMessenger.get_webhook!(id)
  #   with {:ok, %Webhook{}} <- FacebookMessenger.delete_webhook(webhook) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end

defmodule ElixirMessengerBotWeb.WebhookController do
  use ElixirMessengerBotWeb, :controller

  alias ElixirMessengerBot.FacebookMessenger
  alias ElixirMessengerBot.FacebookMessenger.Webhook

  action_fallback ElixirMessengerBotWeb.FallbackController

  # def callback(conn,  %{"hub.challenge" => challenge,  "hub.mode" => mode, "hub.verify_token" => verify_token} = params) do
  def callback(conn, params) do
    challenge = params["hub.challenge"]
    mode      = params["hub.mode"]
    token     = params["hub.verify_token"]
    signature = params["x-hub-signature"]

    IO.puts "------ callback params --------"
    IO.inspect(params)
    IO.puts "------ end of it all --------"

    IO.inspect(challenge)
    # render(conn, "callback.json", data)
    conn
    |> send_resp(200, challenge)
  end

  """
  2017-12-11T12:18:57.187987+00:00 app[web.1]: %{"entry" => [%{"id" => "381841192148151",
2017-12-11T12:18:57.187989+00:00 app[web.1]:      "messaging" => [%{"message" => %{"mid" => "mid.$cAAEBu8xCQlVmdsjQRlgRYOIG2Eua",
2017-12-11T12:18:57.187989+00:00 app[web.1]:           "seq" => 27023, "text" => "hi bot"},
2017-12-11T12:18:57.187990+00:00 app[web.1]:         "recipient" => %{"id" => "381841192148151"},
2017-12-11T12:18:57.187990+00:00 app[web.1]:         "sender" => %{"id" => "1306737552689882"},
2017-12-11T12:18:57.187991+00:00 app[web.1]:         "timestamp" => 1512994736198}], "time" => 1512994736963}],
2017-12-11T12:18:57.187991+00:00 app[web.1]:   "object" => "page"}


  2017-12-11T12:18:53.704532+00:00 app[web.1]: %{"entry" => [%{"id" => "381841192148151",
2017-12-11T12:18:53.704534+00:00 app[web.1]:      "messaging" => [%{"read" => %{"seq" => 0, "watermark" => 1512994540824},
2017-12-11T12:18:53.704535+00:00 app[web.1]:         "recipient" => %{"id" => "381841192148151"},
2017-12-11T12:18:53.704536+00:00 app[web.1]:         "sender" => %{"id" => "1306737552689882"},
2017-12-11T12:18:53.704536+00:00 app[web.1]:         "timestamp" => 1512994733455}], "time" => 1512994733490}],
2017-12-11T12:18:53.704537+00:00 app[web.1]:   "object" => "page"}
  """
  def process(conn, params) do
    challenge = params["hub.challenge"]
    mode      = params["hub.mode"]
    token     = params["hub.verify_token"]
    signature = params["x-hub-signature"]

    %{"entry" => entry, "object" => object} = params

    IO.inspect(entry)
    %{"text" => text, "sender" => sender, "recipient" => recipient } = parse_entry(List.first(entry))

    IO.puts "------ webhook params --------"
    IO.inspect(params)
    IO.puts "------ text --------"
    IO.inspect(text)
    IO.puts "------ end of it all --------"
    HTTPotion.get("www.google.com")

    conn
    |> send_resp(200, "")
  end

  defp parse_entry(%{"id" => id, "messaging" => [%{ "message" => message, "sender" => sender, "recipient" => recipient}]} = entry) do
    IO.puts "received message object"
    IO.inspect(message)
    %{"mid" => mid, "seq" => seq, "text" => text} = message

    parsed = %{"text" => text, "sender" => sender, "recipient" => recipient }

    IO.puts("text is #{text}")
    IO.inspect(parsed)

    send_echo(text, sender)

    parsed
  end

  defp parse_entry(entry) do
    IO.puts "received unknown entry"
    nil
  end

  """
  Facebook reference example:

  curl -X POST -H "Content-Type: application/json" -d '{
  "recipient":{
    "id":"<PSID>"
  },
  "message":{
    "text":"hello, world!"
  }
  }' "https://graph.facebook.com/v2.6/me/messages?access_token=<PAGE_ACCESS_TOKEN>"
"""
  defp send_echo(text, psid) do
    page_access_token = System.get_env("FB_PAGE_ACCESS_TOKEN")
    host = "https://graph.facebook.com/v2.6/me/messages?access_token=#{page_access_token}"

    data = %{
      "recipient" => psid,
      "message"   => %{"text" => "You said: #{text}. I say: no chocolate today." }
    }
    body = data |> Poison.encode!
    headers = ["Accept": "application/json", "Content-Type": "application/json"]

    IO.puts "sending this data:"
    IO.inspect(data)
    resp = HTTPotion.post(host, [body: body, headers: headers])
    IO.puts "sent echo to messenger"

    # send_tweet("@schokotron chocolate please: #{text}")
    IO.inspect(resp)
  end


  defp send_tweet(message) do
    ExTwitter.configure(
      consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
      access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
    )

    resp = ExTwitter.update(message)
    IO.puts "twitter returned: "
    IO.inspect(resp)
    resp
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

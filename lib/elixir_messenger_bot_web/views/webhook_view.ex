defmodule ElixirMessengerBotWeb.WebhookView do
  use ElixirMessengerBotWeb, :view
  alias ElixirMessengerBotWeb.WebhookView

  def render("index.json", %{webhook: webhook}) do
    %{data: render_many(webhook, WebhookView, "webhook.json")}
  end

  def render("show.json", %{webhook: webhook}) do
    %{data: render_one(webhook, WebhookView, "webhook.json")}
  end

  def render("webhook.json", %{webhook: webhook}) do
    %{id: webhook.id}
  end
end

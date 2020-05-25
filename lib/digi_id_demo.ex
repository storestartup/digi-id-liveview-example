defmodule DigiIdDemo do
  @moduledoc """
  DigiIdDemo keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def generate_nonce() do
    length = 16
    :crypto.strong_rand_bytes(length)
      |> Base.url_encode64
      |> binary_part(0, length)
  end

  def callback_url() do
    case Application.get_env(:digi_id_demo, :env) do
      :dev ->
        "#{Ngrok.public_url()}/auth"

      _ ->
        DigiIdDemoWeb.Router.Helpers.auth_url(DigiIdDemoWeb.Endpoint, :auth)
    end
  end

end

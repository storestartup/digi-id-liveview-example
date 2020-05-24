defmodule DigiIdDemoWeb.AuthController do
  use DigiIdDemoWeb, :controller
  require Logger

  @doc """
  webhook from digibyte wallet sent here to indicate a login
  """
  def auth(conn, %{"address" => addr, "signature" => sig, "x" => nonce, "uri" => uri}) do
    # test if it's valid
    case DigiID.signature_valid?(uri, addr, sig) do
      true ->
        # valid, broadcast login msg to nonce channel
        Logger.debug "signature validated"
        Phoenix.PubSub.broadcast(DigiIdDemo.PubSub, "digiid:#{nonce}", {"login", addr})
      _ ->
        Logger.error "Error validating signature!"
    end
    text(conn, "ok")
  end
  def auth(conn, params) do
    Logger.error "received invalid auth params! #{inspect params}"
    conn
    |> put_status(400)
    |> text("Invalid auth params received")
  end
end

defmodule DigiIdDemoWeb.PageLive do
  use DigiIdDemoWeb, :live_view

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    digi = %DigiID{
      callback: DigiIdDemo.callback_url(),
      secure: use_secure(),
      nonce: DigiIdDemo.generate_nonce()
    }

    uri = DigiID.generate_uri(digi)

    state = %{
      logged_in: false,
      address: nil,
      qrcode_url: "/qr?#{URI.encode_query(%{c: uri})}",
      nonce: digi.nonce,
      digiid_uri: uri
    }

    Phoenix.PubSub.subscribe(DigiIdDemo.PubSub, "digiid:#{state.nonce}")

    {:ok, assign(socket, state)}
  end

  @impl true
  def handle_info({"login", addr}, socket) do
    {:noreply, assign(socket, logged_in: true, address: addr)}
  end

  @impl true
  def handle_event("logout", _value, socket) do
    {:noreply, assign(socket, logged_in: false, address: nil)}
  end

  def use_secure() do
    Application.get_env(:digi_id_demo, :env) != :dev
  end

end

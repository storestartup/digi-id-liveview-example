defmodule DigiIdDemoWeb.QrController do
  use DigiIdDemoWeb, :controller

  def generate(conn, %{"c" => c}) do
    png = c
    |> EQRCode.encode()
    |> EQRCode.png()

    conn
    |> put_resp_header("content-type", "image/png")
    |> Plug.Conn.send_resp(:ok, png)
  end

end

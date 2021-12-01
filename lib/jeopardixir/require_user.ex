defmodule Jeopardixir.RequireUser do
  def require_user(conn, _) do
    if JeopardixirWeb.Helpers.Auth.signed_in?(conn) do
      conn
    else
      conn |>
      Phoenix.Controller.put_flash(:error, "You must be signed in to view that page.") |>
      Phoenix.Controller.redirect(to: "/") |>
      Plug.Conn.halt
    end
  end
end

defmodule JeopardixirWeb.PageController do
  use JeopardixirWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

defmodule JeopardixirWeb.PageControllerTest do
  use JeopardixirWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Jeopardixir Index"
  end
end

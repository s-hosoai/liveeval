defmodule LiveevalWeb.PageController do
  use LiveevalWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

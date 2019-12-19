defmodule LiveevalWeb.PageController do
  use LiveevalWeb, :controller
  @length 10

  def index(conn, _params) do
    randomStr =
      :crypto.strong_rand_bytes(@length)
      |> Base.encode64()
      |> binary_part(0, @length)

    redirect(conn, to: "/live/" <> randomStr)
  end
end

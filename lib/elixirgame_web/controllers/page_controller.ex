defmodule ElixirgameWeb.PageController do
  use ElixirgameWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

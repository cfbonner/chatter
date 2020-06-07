defmodule TattlerWeb.PageController do
  use TattlerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => room}) do
    render(conn, "show.html", room: room)
  end
end

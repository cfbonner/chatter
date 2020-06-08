defmodule TattlerWeb.PageController do
  use TattlerWeb, :controller
  alias Tattler.Chat
  alias Tattler.Repo

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => room_id}) do
    {:ok, room} = Chat.find_or_create_room(room_id)
    render(conn, "show.html", room: room)
  end
end

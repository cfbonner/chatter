defmodule TattlerWeb.PageController do
  use TattlerWeb, :controller
  alias Tattler.Chat
  alias Tattler.Repo

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => room_id}) do
    room = 
      case Chat.get_room(room_id) do
        nil -> Chat.create_room(%{friendly_id: room_id})
        chat_room -> chat_room
      end
    render(conn, "show.html", room: room)
  end
end

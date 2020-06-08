defmodule TattlerWeb.RoomChannel do
  use Phoenix.Channel
  import Ecto.Query, warn: false
  alias Tattler.Chat
  alias Tattler.Repo
  
  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end
  def join("room:" <> private_room_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_message", %{"room_id" => room_id, "name" => name, "body" => body}, socket) do
    spawn(fn -> Chat.create_message(%{room_id: room_id, name: name, body: body}) end)
    broadcast!(socket, "new_message", %{name: name, body: body})
    {:noreply, socket}
  end
end


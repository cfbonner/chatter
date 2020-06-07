defmodule TattlerWeb.RoomChannel do
  use Phoenix.Channel
  alias Tattler.Chat
  
  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end
  def join("room:" <> private_room_id, _params, socket) do
    case Tattler.Repo.get_by(Chat.Room, friendly_id: private_room_id) do
      %Chat.Room{} -> {:ok, socket}
      nil ->
        Chat.create_room(%{friendly_id: private_room_id})
        {:ok, socket}
    end
  end

  def handle_in("new_message", %{"name" => name, "body" => body}, socket) do
    broadcast!(socket, "new_message", %{name: name, body: body})
    {:noreply, socket}
  end
end


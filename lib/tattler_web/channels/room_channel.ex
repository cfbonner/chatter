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
        spawn(fn -> Chat.create_room(%{friendly_id: private_room_id}) end)
        {:ok, socket}
    end
  end

  def handle_in("new_message", %{"name" => name, "body" => body}, socket) do
    spawn(fn -> Chat.create_message(%{name: name, body: body}) end)
    broadcast!(socket, "new_message", %{name: name, body: body})
    {:noreply, socket}
  end
end


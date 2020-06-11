defmodule TattlerWeb.RoomChannel do
  use Phoenix.Channel
  import Ecto.Query, warn: false
  alias TattlerWeb.Presence
  alias Tattler.Chat
  
  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end
  def join("room:" <> private_room_id, _params, socket) do
    send(self(), :after_join)
    {:ok, %{room_id: private_room_id}, socket}
  end

  def handle_in("new_message", %{"room_id" => room_id, "name" => name, "body" => body}, socket) do
    spawn(fn -> Chat.create_message(%{room_id: room_id, name: name, body: body}) end)
    broadcast!(socket, "new_message", %{name: name, body: body})
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:second))
    })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end


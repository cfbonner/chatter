defmodule TattlerWeb.RoomChannel do
  use Phoenix.Channel
  
  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end
  def join("room:" <> _private_room_id, _params, socket) do
    {:ok, socket}
    # {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_message", %{"name" => name, "body" => body}, socket) do
    broadcast!(socket, "new_message", %{name: name, body: body})
    {:noreply, socket}
  end
end


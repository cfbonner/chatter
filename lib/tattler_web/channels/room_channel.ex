defmodule TattlerWeb.RoomChannel do
  use Phoenix.Channel
  import Ecto.Query, warn: false
  alias Tattler.Chat
  alias Tattler.Repo
  
  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end
  def join("room:" <> private_room_id, _params, socket) do
    case Repo.get_by(Chat.Room, friendly_id: private_room_id) do
      %Chat.Room{} -> {:ok, socket}
      nil ->
        spawn(fn -> Chat.create_room(%{friendly_id: private_room_id}) end)
        {:ok, socket}
    end
  end

  def handle_in("new_message", %{"name" => name, "body" => body}, socket) do
    spawn(fn ->
      save_message_to_room(socket.topic, %{name: name, body: body})
    end)

    broadcast!(socket, "new_message", %{name: name, body: body})
    {:noreply, socket}
  end

  defp save_message_to_room(room, message) do
    get_room_id_query = 
      fn name -> 
        from(c in Chat.Room, where: c.friendly_id == ^name, select: [:id])
      end
    merge_id_to_message = fn id -> Map.put(message, :room_id, id) end
    attributes =
      room
      |> String.split(":")
      |> Enum.at(1)
      |> get_room_id_query.()
      |> Repo.one()
      |> Map.get(:id)
      |> merge_id_to_message.()

      Chat.create_message(attributes)
  end
end


defmodule Tattler.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tattler.Chat.Room

  schema "messages" do
    field :body, :string
    field :name, :string
    belongs_to :room, Room

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :body, :room_id])
    |> validate_required([:name, :body])
  end
end

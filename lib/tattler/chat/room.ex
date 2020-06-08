defmodule Tattler.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tattler.Chat.Message

  schema "rooms" do
    field :friendly_id, :string
    has_many :messages, Message

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:friendly_id])
    |> validate_required([:friendly_id])
    |> unique_constraint(:friendly_id)
  end
end

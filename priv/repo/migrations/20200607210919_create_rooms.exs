defmodule Tattler.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :friendly_id, :string

      timestamps()
    end

    create unique_index(:rooms, [:friendly_id])
  end
end

defmodule Yearbook.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :photo, :string
      add :name, :string
      add :text, :text
      add :status, :string, default: "pending"

      timestamps(type: :utc_datetime)
    end
  end
end

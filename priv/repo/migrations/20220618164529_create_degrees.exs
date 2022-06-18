defmodule Yearbook.Repo.Migrations.CreateDegrees do
  use Ecto.Migration

  def change do
    create table(:degrees, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :cycle, :integer

      timestamps()
    end
  end
end

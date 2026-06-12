defmodule Yearbook.Repo.Migrations.AddYearToEntries do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :year, :integer, null: false
    end
  end
end

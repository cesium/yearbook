defmodule Yearbook.Repo.Migrations.AddMastersToEntries do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :masters, :boolean, default: false, null: false
    end
  end
end

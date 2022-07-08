defmodule Yearbook.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :year, :integer
      add :academic_year_id, references(:academic_years, on_delete: :nothing, type: :binary_id)
      add :degree_id, references(:degrees, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:classes, [:degree_id])
    create unique_index(:classes, [:academic_year_id, :degree_id, :year])
  end
end

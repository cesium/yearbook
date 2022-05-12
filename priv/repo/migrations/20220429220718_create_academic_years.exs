defmodule Yearbook.Repo.Migrations.CreateAcademicYears do
  use Ecto.Migration

  def change do
    create table(:academic_years, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start, :integer
      add :finish, :integer

      timestamps()
    end
  end
end

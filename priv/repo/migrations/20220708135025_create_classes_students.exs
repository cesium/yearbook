defmodule Yearbook.Repo.Migrations.CreateClassesStudents do
  use Ecto.Migration

  def change do
    create table(:classes_students, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :class_id, references(:classes, on_delete: :nothing, type: :binary_id)
      add :student_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :accepted, :boolean, default: false
      timestamps()
    end

    create index(:classes_students, [:class_id])
    create index(:classes_students, [:student_id])

    create unique_index(:classes_students, [:class_id, :student_id])
  end
end

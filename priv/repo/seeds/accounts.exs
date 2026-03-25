defmodule Yearbook.Repo.Seeds.Accounts do
  alias Yearbook.Repo
  alias Yearbook.Accounts.User

  @names File.read!("priv/fake/names.txt") |> String.split("\n", trim: true)

  def run do
    half = div(length(@names), 2)
    {admin_names, student_names} = Enum.split(@names, half)

    case Repo.all(User) do
      [] ->
        seed_admins(admin_names)
        seed_students(student_names)
      _ ->
        Mix.shell().error("Users already exist in the database. Aborting Accounts seeding.")
    end
  end

  def seed_students(names) do
    for {name, i} <- Enum.with_index(names) do
      email = "student#{i}@yearbook.pt"

      attrs = %{
        email: email,
        password: "password1234"
      }

      case %User{} |> User.registration_changeset(attrs) |> Repo.insert() do
        {:ok, user} ->
          user |> User.confirm_changeset() |> Repo.update!()
        {:error, changeset} ->
          Mix.shell().error("Error creating student #{email}: #{inspect(changeset.errors)}")
      end
    end
    Mix.shell().info("Seeds: Students created successfully.")
  end

  def seed_admins(names) do
    admins_to_create = Enum.take(names, 2)

    for {name, i} <- Enum.with_index(admins_to_create) do
      email = "admin#{i}@yearbook.pt"

      attrs = %{
        email: email,
        password: "password1234",
        role: :admin
      }

      case %User{} |> User.changeset(attrs) |> Repo.insert() do
        {:ok, user} ->
          user |> User.confirm_changeset() |> Repo.update!()
        {:error, changeset} ->
          Mix.shell().error("Error creating admin #{email}: #{inspect(changeset.errors)}")
      end
    end
    Mix.shell().info("Seeds: Admins created successfully.")
  end
end

Yearbook.Repo.Seeds.Accounts.run()

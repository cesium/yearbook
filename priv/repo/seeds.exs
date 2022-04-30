# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Yearbook.Repo.insert!(%Yearbook.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Yearbook.Accounts.User
alias Yearbook.Repo

Repo.delete_all(User)

%User{}
|> User.registration_changeset(%{email: "cesium@di.uminho.pt", password: "Password1234!"})
|> User.confirm_changeset()
|> Repo.insert!()

%User{}
|> User.registration_changeset(%{email: "alex@example.com", password: "Password1234!"})
|> User.confirm_changeset()
|> Repo.insert!()

%User{}
|> User.registration_changeset(%{email: "nelson@example.com", password: "Password1234!"})
|> User.confirm_changeset()
|> Repo.insert!()

alias Yearbook.University.AcademicYear

Repo.delete_all(AcademicYear)

%AcademicYear{}
|> AcademicYear.changeset(%{start: "2021", finish: "2022"})
|> Repo.insert!()

%AcademicYear{}
|> AcademicYear.changeset(%{start: "2022", finish: "2023"})
|> Repo.insert!()

%AcademicYear{}
|> AcademicYear.changeset(%{start: "2023", finish: "2024"})
|> Repo.insert!()

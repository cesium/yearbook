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
|> User.registration_changeset(%{
  name: "CeSIUM",
  email: "cesium@di.uminho.pt",
  password: "Password1234!"
})
|> User.confirm_changeset()
|> Repo.insert!()

alexandre =
  %User{}
  |> User.registration_changeset(%{
    name: "Alexandre Gomes",
    email: "alex@example.com",
    password: "Password1234!"
  })
  |> User.confirm_changeset()
  |> Repo.insert!()

nelson =
  %User{}
  |> User.registration_changeset(%{
    name: "Nelson Estevão",
    email: "nelson@example.com",
    password: "Password1234!"
  })
  |> User.confirm_changeset()
  |> Repo.insert!()

alias Yearbook.University.AcademicYear

Repo.delete_all(AcademicYear)

year2020 =
  %AcademicYear{}
  |> AcademicYear.changeset(%{start: 2020, finish: 2021})
  |> Repo.insert!()

year2021 =
  %AcademicYear{}
  |> AcademicYear.changeset(%{start: 2021, finish: 2022})
  |> Repo.insert!()

year2022 =
  %AcademicYear{}
  |> AcademicYear.changeset(%{start: 2022, finish: 2023})
  |> Repo.insert!()

alias Yearbook.University.Degree

Repo.delete_all(Degree)

lei =
  %Degree{}
  |> Degree.changeset(%{name: "Licenciatura em Engenharia Informática", cycle: 1})
  |> Repo.insert!()

mei =
  %Degree{}
  |> Degree.changeset(%{name: "Mestrado em Engenharia Informática", cycle: 2})
  |> Repo.insert!()

miei =
  %Degree{}
  |> Degree.changeset(%{name: "Mestrado Integrado em Engenharia Informática", cycle: 2})
  |> Repo.insert!()

dei =
  %Degree{}
  |> Degree.changeset(%{name: "Doutoramento em Engenharia Informática", cycle: 3})
  |> Repo.insert!()

alias Yearbook.University.Class

Repo.delete_all(Class)

%Class{}
|> Class.changeset(%{academic_year_id: year2020.id, degree_id: lei.id, grade: 3})
|> Repo.insert!()

%Class{}
|> Class.changeset(%{academic_year_id: year2021.id, degree_id: lei.id, grade: 1})
|> Repo.insert!()

%Class{}
|> Class.changeset(%{academic_year_id: year2021.id, degree_id: lei.id, grade: 2})
|> Repo.insert!()

%Class{}
|> Class.changeset(%{academic_year_id: year2021.id, degree_id: lei.id, grade: 3})
|> Repo.insert!()

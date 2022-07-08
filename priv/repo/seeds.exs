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

Faker.start()

alias Yearbook.Repo

Repo.delete_all(Yearbook.University.ClassStudent)
Repo.delete_all(Yearbook.University.Class)
Repo.delete_all(Yearbook.Accounts.User)
Repo.delete_all(Yearbook.University.AcademicYear)
Repo.delete_all(Yearbook.University.Degree)

alias Yearbook.Accounts.User

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
alias Yearbook.University.ClassStudent

for degree <- [lei, mei, miei, dei],
    academic_year <- [year2020, year2021, year2022],
    year <- [1, 2] do
  class =
    %Class{}
    |> Class.changeset(%{academic_year_id: academic_year.id, degree_id: degree.id, year: year})
    |> Repo.insert!()

  1..10
  |> Enum.each(fn _i ->
    student =
      %User{}
      |> User.registration_changeset(%{
        name: "#{Faker.Person.PtBr.first_name()} #{Faker.Person.PtBr.last_name()}",
        email: Faker.Internet.email(),
        password: "Password1234!"
      })
      |> User.confirm_changeset()
      |> Repo.insert!()

    %ClassStudent{}
    |> ClassStudent.changeset(%{student_id: student.id, class_id: class})
  end)
end

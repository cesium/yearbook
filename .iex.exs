import_file_if_available("~/.iex.exs")
import_file_if_available(".iex.local.exs")

import_if_available(Ecto.Query)
import_if_available(Ecto.Changeset)

alias Yearbook.Repo

alias Yearbook.{
  Accounts,
  University
}

alias Yearbook.Accounts.User

alias Yearbook.University.{
  AcademicYear,
  Class,
  ClassStudent,
  Degree
}

import_file_if_available("~/.iex.exs")

alias Yearbook.Repo

import Ecto.Changeset
import Ecto.Query

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

defmodule Yearbook.Repo.Seeds.Entries do
  alias Yearbook.Repo
  alias Yearbook.Entries.Entry

  @names File.read!("priv/fake/names.txt") |> String.split("\n", trim: true)
  @quotes File.read!("priv/fake/quotes.txt") |> String.split("\n", trim: true)

  def run do
    case Repo.all(Entry) do
      [] -> seed_all_entries()
      _ -> Mix.shell().error("Entries already exist. Aborting seeding.")
    end
  end

  def seed_all_entries do
    for {name, i} <- Enum.with_index(Enum.take(@names, 17)) do
      attrs = %{
        name: name,
        text: Enum.random(@quotes),
        status: :pending,
        photo: "https://i.pravatar.cc/150?u=entry#{i}"
      }

      case %Entry{} |> Entry.changeset(attrs) |> Repo.insert() do
        {:ok, _entry} -> :ok
        {:error, changeset} ->
          Mix.shell().error("Error creating entry for #{name}: #{inspect(changeset.errors)}")
      end
    end
    Mix.shell().info("Seeds: Entries created successfully.")
  end
end

Yearbook.Repo.Seeds.Entries.run()

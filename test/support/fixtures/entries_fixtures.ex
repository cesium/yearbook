defmodule Yearbook.EntriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Yearbook.Entries` context.
  """

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        name: "some name",
        photo: "some photo",
        status: :pending,
        text: "some text"
      })
      |> Yearbook.Entries.create_entry()

    entry
  end
end

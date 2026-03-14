defmodule Yearbook.EntriesTest do
  use Yearbook.DataCase

  alias Yearbook.Entries

  describe "entries" do
    alias Yearbook.Entries.Entry

    import Yearbook.EntriesFixtures

    @invalid_attrs %{name: nil, status: nil, text: nil, photo: nil}

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Entries.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Entries.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      valid_attrs = %{name: "some name", status: :pending, text: "some text", photo: "some photo"}

      assert {:ok, %Entry{} = entry} = Entries.create_entry(valid_attrs)
      assert entry.name == "some name"
      assert entry.status == :pending
      assert entry.text == "some text"
      assert entry.photo == "some photo"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entries.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()

      update_attrs = %{
        name: "some updated name",
        status: :accepted,
        text: "some updated text",
        photo: "some updated photo"
      }

      assert {:ok, %Entry{} = entry} = Entries.update_entry(entry, update_attrs)
      assert entry.name == "some updated name"
      assert entry.status == :accepted
      assert entry.text == "some updated text"
      assert entry.photo == "some updated photo"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Entries.update_entry(entry, @invalid_attrs)
      assert entry == Entries.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Entries.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Entries.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Entries.change_entry(entry)
    end
  end
end

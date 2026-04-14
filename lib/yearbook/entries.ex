defmodule Yearbook.Entries do
  @moduledoc """
  The Entries context.
  """

  import Ecto.Query, warn: false
  alias Yearbook.Repo

  alias Yearbook.Entries.Entry

  @doc """
  Returns the list of entries.

  ## Examples

      iex> list_entries()
      [%Entry{}, ...]

  """
  def list_entries do
    Repo.all(Entry)
  end

  @doc """
  Returns the list of pending entries.
  """

  def list_pending_entries do
    query =
      from e in Entry,
        where: e.status == :pending,
        order_by: [desc: e.inserted_at]

    Repo.all(query)
  end

  @doc """
  Returns a paginated map of pending entries based on the provided parameters.

  ## Examples
      iex> list_pending_entries_pagination(%{"page" => "1"})
      %{
        entries: [%Entry{}, ...],
        total_pages: 9,
        current_page: 1,
        total_count: 83
      }
  """
  def list_pending_entries_pagination(params \\ %{}) do
    query =
      Entry
      |> where([e], e.status == :pending)

    query =
      case {List.wrap(params["order_by"]), List.wrap(params["order_directions"])} do
        {[field | _], [dir | _]} when dir in ["asc", "desc"] ->
          direction = String.to_atom(dir)
          field_atom = String.to_atom(field)
          order_by(query, [e], [{^direction, field(e, ^field_atom)}])

        _ ->
          order_by(query, [e], desc: e.inserted_at)
      end

    paginate(query, params)
  end

  defp paginate(query, params) do
    page = String.to_integer(params["page"] || "1")
    per_page = 10

    entries =
      query
      |> limit(^per_page)
      |> offset(^((page - 1) * per_page))
      |> Repo.all()

    total_entries = Repo.aggregate(query, :count)
    total_pages = max(1, ceil(total_entries / per_page))

    %{
      entries: entries,
      total_pages: total_pages,
      current_page: page,
      total_count: total_entries
    }
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

      iex> get_entry!(123)
      %Entry{}

      iex> get_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entry!(id), do: Repo.get!(Entry, id)

  @doc """
  Creates a entry.

  ## Examples

      iex> create_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(attrs) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a entry.

  ## Examples

      iex> update_entry(entry, %{field: new_value})
      {:ok, %Entry{}}

      iex> update_entry(entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entry(%Entry{} = entry, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a entry.

  ## Examples

      iex> delete_entry(entry)
      {:ok, %Entry{}}

      iex> delete_entry(entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry changes.

  ## Examples

      iex> change_entry(entry)
      %Ecto.Changeset{data: %Entry{}}

  """
  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    Entry.changeset(entry, attrs)
  end
end

defmodule YearbookWeb.ViewUtils do
  @moduledoc """
  Utility functions to be used on all views.
  """

  @doc """
  Utility function to obtain the initials of a name.

  ## Examples

    iex> extract_initials("José Valim")
    "JV"

    iex> extract_initials("Nelson Miguel Estevão")
    "NE"

    iex> extract_initials("    Nelson    Miguel   Estevão   ")
    "NE"

    iex> extract_initials("Chris")
    "C"
  """
  def extract_initials(name) do
    name
    |> String.split()
    |> then(fn
      names when length(names) >= 2 ->
        [List.first(names), List.last(names)]

      names ->
        [hd(names)]
    end)
    |> Enum.map_join(fn x -> String.first(x) end)
  end
end

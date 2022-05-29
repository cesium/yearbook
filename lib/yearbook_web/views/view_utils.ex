defmodule YearbookWeb.ViewUtils do
  def extract_initials(name) do
    name
    |> String.split()
    |> then(fn
      names when length(names) >= 2 ->
        [List.first(names), List.last(names)]

      names ->
        [hd(names)]
    end)
    |> Enum.map(fn x -> String.first(x) end)
    |> Enum.join()
  end
end

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

  def contact do
    %{
      description: """
      O CeSIUM é o Centro de estudantes de Engenharia Informática da
      Universidade do Minho composto por estudantes voluntários que têm como
      objectivo principal representar e promover o curso. É um núcleo unido e
      dinâmico, capaz de proporcionar experiências únicas e enriquecedoras para a
      tua futura vida profissional.
      """,
      address: """
      Departamento de Informática - Sala 1.04
      Campus de Gualtar, 4710-057 Braga
      """,
      email: "cesium@di.uminho.pt",
      phone: "+351 253 604 448",
      social: social()
    }
  end

  def footer do
    %{
      description: """
      O CeSIUM é o centro de estudantes que tem como missão representar e
      promover o curso de Engenharia Informática da Universidade do Minho.
      """,
      social: social()
    }
  end

  defp social do
    %{
      facebook: "https://facebook.com/cesiuminho",
      twitter: "https://twitter.com/cesiuminho",
      instagram: "https://instagram.com/cesiuminho",
      github: "https://github.com/cesium"
    }
  end
end

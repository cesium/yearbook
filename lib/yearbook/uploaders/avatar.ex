defmodule Yearbook.Uploaders.Avatar do
  @moduledoc """
  An avatar is profile picture to be used on the yearbook.
  """
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]
  @allowlist ~w(.jpg .jpeg .gif .png)

  @doc """
  Validate file extensions for avatar usage.
  """
  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    case Enum.member?(@allowlist, file_extension) do
      true -> :ok
      false -> {:error, "invalid file type"}
    end
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  end

  def filename(version, _) do
    version
  end

  def storage_dir(_version, {_file, scope}) do
    "uploads/user/avatars/#{scope.id}"
  end

  # def default_url(_version, _scope) do
  #   YearbookWeb.Endpoint.url() <> "/images/defaults/avatars/default.png"
  # end
end

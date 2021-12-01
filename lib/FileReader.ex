defmodule Aoc.FileReader do
  def get_lines(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
  end

  def get_json(filename) do
    with {:ok, body} <- File.read(filename), {:ok, json} <- Poison.decode(body), do: {:ok, json}
  end
end

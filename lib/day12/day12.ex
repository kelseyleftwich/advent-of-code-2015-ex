defmodule Day12 do
  alias Aoc.FileReader

  def solve() do
    FileReader.get_json("lib/day12/puzzleInput.json")
    |> elem(1)
    |> parse_numbers_from_json()
  end

  def parse_numbers_from_json(input) do
    parse_numbers_from_json(input, 0)
  end

  def parse_numbers_from_json(input, count) when is_number(input) do
    count + input
  end

  def parse_numbers_from_json(input, count) when is_list(input) do
    input
    |> Enum.reduce(count, fn elem, acc ->
      elem
      |> parse_numbers_from_json(acc)
    end)
  end

  def parse_numbers_from_json(input, count) when is_map(input) do
    input
    |> Map.values()
    |> Enum.find(fn key -> key == "red" end)
    |> case do
      nil ->
        input
        |> Enum.reduce(count, fn elem, acc ->
          elem
          |> parse_numbers_from_json(acc)
        end)

      _ ->
        count
    end
  end

  def parse_numbers_from_json({input_a, input_b}, count) do
    count =
      input_a
      |> parse_numbers_from_json(count)

    input_b
    |> parse_numbers_from_json(count)
  end

  def parse_numbers_from_json(input, count) when is_binary(input) do
    count
  end
end

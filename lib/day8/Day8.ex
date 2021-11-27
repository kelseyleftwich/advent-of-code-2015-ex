defmodule Aoc.Day8 do
  alias Aoc.FileReader

  def part_1(path \\ "lib/day8/puzzleInput.txt") do
    input = FileReader.get_lines(path)

    a =
      input
      |> code_length()

    b =
      input
      |> memory_length()

    a - b
  end

  def code_length(input) when is_binary(input) do
    input
    |> String.length()
  end

  def code_length(input) when is_list(input) do
    input
    |> Enum.join("")
    |> code_length()
  end

  def memory_length(input) when is_list(input) do
    input
    |> Enum.reduce(0, fn line, acc ->
      line
      |> memory_length()
      |> Kernel.+(acc)
    end)
  end

  def memory_length(input) when is_binary(input) do
    input
    # remove unescaped quotes
    |> replace_hexadecimal()
    |> String.slice(1..-1)
    |> String.slice(0..-2)
    |> String.replace("\\\"", ".")
    |> String.replace("\\\\", "x")
    |> String.length()
  end

  def replace_hexadecimal(input) do
    # hex_regex = ~r/\\x\d\d/
    hex_regex = ~r/\\x(\d|a|b|c|d|e|f)(\d|a|b|c|d|e|f)/

    hex_regex
    |> Regex.replace(input, "!")
  end
end

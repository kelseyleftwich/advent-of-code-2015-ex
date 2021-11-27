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

  def part_2(path \\ "lib/day8/puzzleInput.txt") do
    input = FileReader.get_lines(path)

    b =
      input
      |> code_length()

    a =
      input
      |> encode()

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
    |> decode_hexadecimal()
    |> String.slice(1..-1)
    |> String.slice(0..-2)
    |> String.replace("\\\"", ".")
    |> String.replace("\\\\", "x")
    |> String.length()
  end

  def decode_hexadecimal(input) do
    # hex_regex = ~r/\\x\d\d/
    hex_regex = ~r/\\x(\d|a|b|c|d|e|f)(\d|a|b|c|d|e|f)/

    hex_regex
    |> Regex.replace(input, "!")
  end

  def encode(input) when is_list(input) do
    input
    |> Enum.reduce(0, fn line, acc ->
      line
      |> encode()
      |> String.length()
      |> Kernel.+(acc)
    end)
  end

  def encode(input) do
    input
    |> encode_hexadecimal()
    |> encode_slash()
    |> encode_quotes()
    |> wrap_quotes()
  end

  @hex_regex ~r/\\x(\d|a|b|c|d|e|f)(\d|a|b|c|d|e|f)/

  def encode_hexadecimal(input) do
    @hex_regex
    |> Regex.replace(input, fn match, _ -> "\\#{match}" end)
  end

  @encoded_hex_regex ~r/\\\\x(\d|a|b|c|d|e|f)(\d|a|b|c|d|e|f)/

  def encode_slash(input) do
    @encoded_hex_regex
    |> Regex.replace(input, fn match, _ -> String.duplicate(".", match |> String.length()) end)
    |> String.replace("\\", "\\\\")
  end

  def encode_quotes(input) do
    input
    |> String.replace("\"", "\\\"")
  end

  def wrap_quotes(input) do
    "\"#{input}\""
  end
end

defmodule Aoc.Binary do
  def parse_decimal_input_to_binary(decimal_input_string) do
    decimal_input_string
    |> String.to_integer()
    |> Integer.to_string(2)
    |> String.pad_leading(16, "0")
  end

  def parse_binary_to_decimal_input(binary_input) do
    binary_input
    |> String.to_integer(2)
    |> Integer.to_string()
  end
end

defmodule Aoc.Gates do
  @spec not binary :: binary
  def not input do
    input
    |> String.graphemes()
    |> Enum.map(fn
      "0" -> "1"
      "1" -> "0"
    end)
    |> Enum.join("")
  end

  @spec lshift(binary, number()) :: binary
  def lshift(input, places) do
    output =
      input
      |> String.slice(places..-1)
      |> String.pad_trailing(16, "0")

    output
  end

  @spec rshift(binary, number()) :: binary
  def rshift(input, places) do
    places = places |> Kernel.+(1) |> Kernel.*(-1)

    output =
      input
      |> String.slice(0..places)
      |> String.pad_leading(16, "0")

    output
  end

  # if both bits in the compared position are 1, the bit in the resulting binary representation is 1 (1 × 1 = 1);
  # otherwise, the result is 0 (1 × 0 = 0 and 0 × 0 = 0)
  def gate_and(left, right) do
    left
    |> String.graphemes()
    |> Stream.with_index()
    |> Stream.map(fn {left_char, index} ->
      right_value = right |> String.at(index) |> String.to_integer()

      left_char
      |> String.to_integer()
      |> Kernel.*(right_value)
      |> Integer.to_string()
    end)
    |> Enum.join("")
  end

  # result in each position is 0 if both bits are 0, while otherwise the result is 1
  def gate_or(left, right) do
    output =
      left
      |> String.graphemes()
      |> Stream.with_index()
      |> Stream.map(fn {left_char, index} ->
        right_char = right |> String.at(index)

        with "0" <- left_char, "0" <- right_char do
          "0"
        else
          _ ->
            "1"
        end
      end)
      |> Enum.join("")

    output
  end
end

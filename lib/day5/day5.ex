defmodule Aoc.Day5 do
  @unallowed_strings ["ab", "cd", "pq", "xy"]

  def part_1() do
    file = "lib/day5/puzzleInput.txt"

    file
    |> File.read!()
    |> String.split("\n")
    |> Stream.filter(fn line ->
      is_nice_string?(line)
    end)
    |> Enum.count()
  end

  @spec is_nice_string?(String.t()) :: boolean()
  def is_nice_string?(input) do
    has_at_least_three_vowels?(input) and
      has_at_least_one_adjacent_repeating_char?(input) and
      not contains_any_unallowed_strings?(input)
  end

  @spec has_at_least_three_vowels?(String.t()) :: boolean()
  def has_at_least_three_vowels?(input) do
    input
    |> String.graphemes()
    |> Enum.filter(fn letter -> letter in ["a", "e", "i", "o", "u"] end)
    |> Enum.count()
    |> Kernel.>=(3)
  end

  @spec has_at_least_one_adjacent_repeating_char?(String.t()) :: boolean()
  def has_at_least_one_adjacent_repeating_char?(input) do
    input
    |> String.graphemes()
    |> Enum.reduce([false, []], fn current_char, acc ->
      [pass, stack] = acc

      adjacent? = current_char_is_on_top_of_stack?(current_char, stack)

      [pass or adjacent?, [current_char | stack]]
    end)
    |> Kernel.hd()
  end

  @spec current_char_is_on_top_of_stack?(any, list(String.t())) :: boolean
  def current_char_is_on_top_of_stack?(_current_char, []) do
    false
  end

  def current_char_is_on_top_of_stack?(current_char, [first_elem]) do
    current_char == first_elem
  end

  def current_char_is_on_top_of_stack?(current_char, [first_elem | _tail]) do
    current_char == first_elem
  end

  @spec contains_any_unallowed_strings?(String.t()) :: boolean()
  def contains_any_unallowed_strings?(input) do
    @unallowed_strings
    |> Enum.any?(fn unallowed_string ->
      input |> String.contains?(unallowed_string)
    end)
  end

  @spec split_pairs(String.t()) :: list(String.t())
  def split_pairs(input) do
    for <<x::binary-2 <- input>>, do: x
  end

  @spec has_repeating_pair?(String.t()) :: boolean()
  def has_repeating_pair?(input) do
    {pair, rest} = input |> String.split_at(2)
    pair_in_rest?(pair, rest)
  end

  def pair_in_rest?(_pair, "") do
    false
  end

  def pair_in_rest?(pair, rest) do
    rest
    |> String.contains?(pair)
    |> if do
      true
    else
      {_old_a, new_a} = pair |> String.split_at(1)
      {new_b, rest} = rest |> String.split_at(1)
      pair_in_rest?(new_a <> new_b, rest)
    end
  end

  @spec has_divided_pair?(String.t() | list(String.t())) :: boolean()
  def has_divided_pair?(input) when is_binary(input) do
    input |> String.graphemes() |> has_divided_pair?()
  end

  def has_divided_pair?([a | [b | [c | tail]]]) do
    if a == c do
      true
    else
      has_divided_pair?([b, c | tail])
    end
  end

  def has_divided_pair?(_list) do
    false
  end

  def part_2() do
    file = "lib/day5/puzzleInput.txt"

    file
    |> File.read!()
    |> String.split("\n")
    |> Stream.filter(fn line ->
      has_divided_pair?(line) and has_repeating_pair?(line)
    end)
    |> Enum.count()
  end
end

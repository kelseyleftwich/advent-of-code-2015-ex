defmodule Aoc.Day11 do
  @alphabet_libray ?a..?z |> Enum.map(&to_string([&1]))
  require Formulae.Combinators

  def iterate_to_valid_password(input) do
    {remaining, starting_char} =
      input
      |> String.split_at(-1)

    remaining_length = remaining |> String.length()

    space_to_fill = 8 - remaining_length

    valid_passwords =
      space_to_fill
      |> get_permutations()
      |> Stream.filter(fn [hd | _] -> hd > starting_char end)
      |> Stream.map(fn perm -> perm |> Enum.join("") end)
      |> Stream.map(fn perm -> "#{remaining}#{perm}" end)
      |> Enum.map(fn candidate -> {candidate, valid_password?(candidate)} end)
      |> Enum.filter(fn {_candidate, is_valid?} -> is_valid? end)

    valid_passwords
    |> Enum.count()
    |> Kernel.<(1)
    |> if do
      iterate_to_valid_password(remaining)
    else
      valid_passwords
      |> Enum.at(0)
      |> elem(0)
    end
  end

  # Formulae doesn't have a dynamic number function for repeated_permutations
  def get_permutations(1), do: @alphabet_libray |> Formulae.Combinators.repeated_permutations(1)
  def get_permutations(2), do: @alphabet_libray |> Formulae.Combinators.repeated_permutations(2)
  def get_permutations(3), do: @alphabet_libray |> Formulae.Combinators.repeated_permutations(3)
  def get_permutations(4), do: @alphabet_libray |> Formulae.Combinators.repeated_permutations(4)
  def get_permutations(5), do: @alphabet_libray |> Formulae.Combinators.repeated_permutations(5)
  def get_permutations(6), do: @alphabet_libray |> Formulae.Combinators.repeated_permutations(6)
  def get_permutations(7), do: @alphabet_libray |> Formulae.Combinators.repeated_permutations(7)
  def get_permutations(8), do: @alphabet_libray |> Formulae.Combinators.repeated_permutations(8)

  def get_new_letter(new_letter_index) do
    if new_letter_index >=
         @alphabet_libray
         |> Enum.count() do
      @alphabet_libray
      |> hd()
    else
      @alphabet_libray
      |> Enum.at(new_letter_index)
    end
  end

  def valid_password?(input) do
    first_rule =
      input
      |> has_three_sequential?()

    second_rule = input |> has_invalid_characters?() |> Kernel.not()

    third_rule = input |> has_two_pairs?()

    first_rule and second_rule and third_rule
  end

  def has_three_sequential?(input) do
    input
    |> String.graphemes()
    |> Enum.reduce({false, []}, fn
      current_char, {false, []} ->
        {false, [current_char]}

      current_char, {false, [first]} ->
        {false, [current_char, first]}

      current_char, {is_valid?, char_stack} ->
        [middle | [first | _]] = char_stack
        first = get_letter_index(first)
        middle = get_letter_index(middle)
        last = get_letter_index(current_char)

        in_sequence? = first == middle - 1 and middle == last - 1

        {
          is_valid? or in_sequence?,
          [current_char | char_stack]
        }
    end)
    |> elem(0)
  end

  def has_two_pairs?(input) do
    input
    |> String.graphemes()
    |> Enum.reduce(%{used: [], pairs: []}, fn
      current_char, %{used: []} = acc ->
        acc
        |> Map.put(
          :used,
          [current_char]
        )

      current_char, %{used: [top | _rest] = used, pairs: pairs} ->
        if top == current_char do
          %{used: [], pairs: [current_char | pairs]}
        else
          %{used: [current_char | used], pairs: pairs}
        end
    end)
    |> Map.get(:pairs)
    |> Enum.count()
    |> Kernel.>(1)
  end

  def has_invalid_characters?(input) do
    input
    |> String.contains?(["i", "o", "l"])
  end

  def get_letter_index(letter) do
    @alphabet_libray
    |> Enum.find_index(fn elem -> elem == letter end)
  end
end

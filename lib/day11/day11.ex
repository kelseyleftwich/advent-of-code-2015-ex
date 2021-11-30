defmodule Aoc.Day11 do
  @alphabet_library ?a..?z |> Enum.map(&to_string([&1]))

  def fetch_new_password(input) do
    next_pass =
      input
      |> new_password()

    next_pass
    |> valid_password?()
    |> if do
      next_pass
    else
      next_pass |> fetch_new_password()
    end
  end

  def new_password(input) do
    password_chars = input |> String.graphemes()

    index = -1

    password_chars
    |> wrap(index)
    |> Enum.join("")
  end

  def wrap(input, index) do
    input
    |> Enum.at(index)
    |> is_last_letter?()
    |> if do
      input
      |> List.replace_at(index, "a")
      |> wrap(index - 1)
    else
      next_letter = iterate_letter(input |> Enum.at(index))

      input
      |> List.replace_at(index, next_letter)
    end
  end

  def is_last_letter?(letter), do: letter == "z"

  def iterate_letter(letter) do
    new_index =
      @alphabet_library
      |> Enum.find_index(fn char -> char === letter end)
      |> Kernel.+(1)
      |> rem(26)

    @alphabet_library
    |> Enum.at(new_index)
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
    @alphabet_library
    |> Enum.find_index(fn elem -> elem == letter end)
  end
end

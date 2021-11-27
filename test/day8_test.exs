defmodule TestDay8 do
  use ExUnit.Case
  alias Aoc.Day8
  alias Aoc.FileReader

  #   "" is 2 characters of code (the two double quotes), but the string contains zero characters.
  # "abc" is 5 characters of code, but 3 characters in the string data.
  # "aaa\"aaa" is 10 characters of code, but the string itself contains six "a" characters and a single, escaped quote character, for a total of 7 characters in the string data.
  # "\x27" is 6 characters of code, but the string itself contains just one - an apostrophe ('), escaped using hexadecimal notation.

  test "part 1 sample" do
    sample = FileReader.get_lines("lib/day8/sampleInput.txt")

    assert Day8.code_length(sample) == 23

    assert Day8.memory_length(sample) == 11

    assert Day8.part_1("lib/day8/sampleInput.txt") == 12
  end

  test "part 2 sample" do
    sample = FileReader.get_lines("lib/day8/sampleInput.txt")

    code_length = Day8.code_length(sample)

    encode_length = Day8.encode(sample)

    assert code_length == 23

    assert encode_length == 42

    assert Day8.part_2("lib/day8/sampleInput.txt") == 19
  end
end

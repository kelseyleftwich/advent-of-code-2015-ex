defmodule TestDay5 do
  use ExUnit.Case
  alias Aoc.Day5

  describe "part 1" do
    # It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
    test "has at least three vowels" do
      assert Day5.has_at_least_three_vowels?("aei")
      assert Day5.has_at_least_three_vowels?("xazegov")
      assert Day5.has_at_least_three_vowels?("aeiouaeiouaeiou")

      refute Day5.has_at_least_three_vowels?("xxx")
      refute Day5.has_at_least_three_vowels?("a")
      refute Day5.has_at_least_three_vowels?("")
    end

    # It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
    test "contains at least one letter that appears twice in a row" do
      assert Day5.has_at_least_one_adjacent_repeating_char?("xx")
      assert Day5.has_at_least_one_adjacent_repeating_char?("abcdde")
      assert Day5.has_at_least_one_adjacent_repeating_char?("aabbccdd")

      refute Day5.has_at_least_one_adjacent_repeating_char?("x")
      refute Day5.has_at_least_one_adjacent_repeating_char?("abcd")
    end

    # It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
    test "contains the strings ab, cd, pq, or xy" do
      assert Day5.contains_any_unallowed_strings?("ab")
      assert Day5.contains_any_unallowed_strings?("xxxcd")
      assert Day5.contains_any_unallowed_strings?("xxpqxx")
      assert Day5.contains_any_unallowed_strings?("yyxy")

      refute Day5.contains_any_unallowed_strings?("eee")
    end

    test "is nice string" do
      # ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and none of the disallowed substrings.
      assert Day5.is_nice_string?("ugknbfddgicrmopn")

      # aaa is nice because it has at least three vowels and a double letter, even though the letters used by different rules overlap.
      assert Day5.is_nice_string?("aaa")

      # jchzalrnumimnmhp is naughty because it has no double letter.
      refute Day5.is_nice_string?("jchzalrnumimnmhp")

      # haegwjzuvuyypxyu is naughty because it contains the string xy.
      refute Day5.is_nice_string?("haegwjzuvuyypxyu")

      # dvszwmarrgswjxmb is naughty because it contains only one vowel.
      refute Day5.is_nice_string?("dvszwmarrgswjxmb")
    end
  end

  describe "part 2" do
    test "has repeating pair" do
      assert "qjhvhtzxzqqjkmpb" |> Day5.has_repeating_pair?()
      assert "xxyxx" |> Day5.has_repeating_pair?()
      assert "uurcxstgmygtbstg" |> Day5.has_repeating_pair?()

      refute "ieodomkazucvgmuy" |> Day5.has_repeating_pair?()
    end

    test "has divided pair" do
      assert "qjhvhtzxzqqjkmpb" |> Day5.has_divided_pair?()
      assert "xxyxx" |> Day5.has_divided_pair?()

      refute "uurcxstgmygtbstg" |> Day5.has_divided_pair?()

      assert "ieodomkazucvgmuy" |> Day5.has_divided_pair?()
    end
  end
end

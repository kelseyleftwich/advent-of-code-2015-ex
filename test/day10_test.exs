defmodule TestDay10 do
  use ExUnit.Case
  alias Aoc.Day10

  # 1 becomes 11 (1 copy of digit 1).
  # 11 becomes 21 (2 copies of digit 1).
  # 21 becomes 1211 (one 2 followed by one 1).
  # 1211 becomes 111221 (one 1, one 2, and two 1s).
  # 111221 becomes 312211 (three 1s, two 2s, and one 1).

  test "look and say" do
    assert Day10.look_and_say("211") == "1221"
    assert Day10.look_and_say("11") == "21"
    assert Day10.look_and_say("21") == "1211"
    assert Day10.look_and_say("1211") == "111221"
    assert Day10.look_and_say("111221") == "312211"
  end
end

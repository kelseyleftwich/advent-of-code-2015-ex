defmodule TestDay4 do
  use ExUnit.Case

  describe "part 1" do
    test "first example" do
      assert Aoc.Day4.part_1("abcdef") == 609_043
    end

    test "second example" do
      assert Aoc.Day4.part_1("pqrstuv") == 1_048_970
    end
  end
end

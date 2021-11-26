defmodule TestDay7 do
  use ExUnit.Case
  alias Aoc.Day7

  # Expected wire signals
  # d: 72
  # e: 507
  # f: 492
  # g: 114
  # h: 65412
  # i: 65079
  # x: 123
  # y: 456

  test "sample input part 1" do
    output = Day7.get_processed_wire_dictionary("lib/day7/sample.txt")

    assert output == %{
             "d" => "72",
             "e" => "507",
             "f" => "492",
             "g" => "114",
             "h" => "65412",
             "i" => "65079",
             "x" => "123",
             "y" => "456"
           }
  end
end

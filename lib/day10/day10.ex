defmodule Aoc.Day10 do
  def part_1(input \\ "1113122113") do
    1..40
    |> Enum.reduce(input, fn _curr, acc ->
      acc
      |> look_and_say()
    end)
    |> String.length()
  end

  def part_2(input \\ "1113122113") do
    1..50
    |> Enum.reduce(input, fn _curr, acc ->
      acc
      |> look_and_say()
    end)
    |> String.length()
  end

  @spec look_and_say(String.t()) :: String.t()
  def look_and_say(input) do
    input
    |> String.graphemes()
    |> Enum.reduce(%{output: "", stack: []}, fn
      current_digit, %{stack: []} = acc ->
        acc
        |> Map.put(:stack, [current_digit])

      current_digit, acc ->
        process_digit(acc, current_digit)
    end)
    |> process_digit(nil)
    |> Map.get(:output)
  end

  @type look_and_say_acc :: %{stack: list(String.t()), output: String.t()}

  @spec process_digit(look_and_say_acc(), String.t() | nil) :: look_and_say_acc()
  def process_digit(%{stack: stack, output: output} = acc, current_digit) do
    [prev | _] = stack

    if prev == current_digit do
      acc
      |> Map.put(:stack, [current_digit | stack])
    else
      count = stack |> Enum.count()

      acc
      |> Map.put(:output, "#{output}#{count}#{prev}")
      |> Map.put(:stack, [current_digit])
    end
  end
end

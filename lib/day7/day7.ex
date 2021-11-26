defmodule Aoc.Day7 do
  alias Aoc.Gates
  alias Aoc.Binary
  @type instruction :: String.t()
  @type wire :: String.t()

  def solve(path \\ "lib/day7/puzzleInput.txt") do
    get_processed_wire_dictionary(path)
    |> Map.get("a")
  end

  def get_processed_wire_dictionary(path) do
    {%{}, get_wires(path)}
    |> process_wire_dictionary()
  end

  def get_wires(path) do
    instructions = Aoc.FileReader.get_lines(path)

    instructions
    |> process_instructions()
  end

  def process_instructions(instructions) do
    instructions
    |> Enum.reduce(%{}, fn instruction, acc ->
      [expression, wire] =
        instruction
        |> get_expression_and_wire()

      Map.put(acc, wire, expression)
    end)
  end

  def get_expression_and_wire(instruction) do
    [left, wire] =
      instruction
      |> String.split(" -> ")

    expression = left |> String.split(" ")

    [expression, wire]
  end

  def process_wire_dictionary({c, wires}) when wires == %{} do
    c
  end

  def process_wire_dictionary({c, wires}) do
    wires
    |> Enum.reduce({c, %{}}, fn {wire, values}, {computed, remaining} ->
      with true <- is_computed?(values),
           value <- values |> Enum.at(0),
           computed <- computed |> Map.put(wire, value) do
        {computed, remaining}
      else
        _ ->
          values =
            values
            |> Enum.map(fn val ->
              Map.get(computed, val, val)
            end)

          values = get_processed_values(values)

          remaining =
            remaining
            |> Map.put(wire, values)

          {computed, remaining}
      end
    end)
    |> process_wire_dictionary()
  end

  def get_processed_values([left, _operator, right] = values) do
    with {_left_parsed, ""} <- Integer.parse(left, 10),
         {_right_parse, ""} <- Integer.parse(right, 10) do
      process_expression(values)
      |> Binary.parse_binary_to_decimal_input()
      |> List.wrap()
    else
      _ ->
        values
    end
  end

  def get_processed_values([_operator, right] = values) do
    with {_right_parse, ""} <- Integer.parse(right, 10) do
      process_expression(values)
      |> Binary.parse_binary_to_decimal_input()
      |> List.wrap()
    else
      _ ->
        values
    end
  end

  def get_processed_values([_right] = values) do
    values
  end

  def is_computed?([value]) do
    value
    |> Integer.parse(10)
    |> case do
      :error ->
        false

      _ ->
        true
    end
  end

  def is_computed?(_), do: false

  def parse_terms(left, right) do
    left = left |> Aoc.Binary.parse_decimal_input_to_binary()
    right = right |> Aoc.Binary.parse_decimal_input_to_binary()

    [left, right]
  end

  def parse_terms(term) do
    term
    |> Aoc.Binary.parse_decimal_input_to_binary()
  end

  def process_expression([left, "AND", right]) do
    [left, right] = parse_terms(left, right)
    Gates.gate_and(left, right)
  end

  def process_expression([left, "OR", right]) do
    [left, right] = parse_terms(left, right)
    Gates.gate_or(left, right)
  end

  def process_expression([left, "LSHIFT", right]) do
    left = parse_terms(left)
    right = right |> String.to_integer()
    Gates.lshift(left, right)
  end

  def process_expression([left, "RSHIFT", right]) do
    left = parse_terms(left)
    right = right |> String.to_integer()
    Gates.rshift(left, right)
  end

  def process_expression(["NOT", term]) do
    term = parse_terms(term)
    Gates.not(term)
  end

  def process_expression([term]) do
    parse_terms(term)
  end
end

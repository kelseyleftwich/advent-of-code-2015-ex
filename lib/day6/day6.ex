defmodule Aoc.Day6 do
  @type light_grid :: map()
  @type coordinate_pair :: {number(), number()}

  @spec build_grid(number(), number()) :: map()
  def build_grid(width, height) do
    empty_row = List.duplicate(0, width)
    empty_list = List.duplicate(empty_row, height)

    Matrix.from_list(empty_list)
  end

  @spec turn_on_lights(light_grid(), coordinate_pair(), coordinate_pair()) :: light_grid()
  def turn_on_lights(grid, corner_a, corner_b) do
    get_target_cells(corner_a, corner_b)
    |> Enum.reduce(grid, fn {x, y}, acc ->
      put_in(acc[x][y], 1)
    end)
  end

  @spec turn_off_lights(light_grid(), coordinate_pair(), coordinate_pair()) :: light_grid()
  def turn_off_lights(grid, corner_a, corner_b) do
    get_target_cells(corner_a, corner_b)
    |> Enum.reduce(grid, fn {x, y}, acc ->
      put_in(acc[x][y], 0)
    end)
  end

  @spec toggle_lights(light_grid(), coordinate_pair(), coordinate_pair()) :: light_grid()
  def toggle_lights(grid, corner_a, corner_b) do
    get_target_cells(corner_a, corner_b)
    |> Enum.reduce(grid, fn {x, y}, acc ->
      current_state = grid[x][y]
      put_in(acc[x][y], toggle_light(current_state))
    end)
  end

  def toggle_light(1), do: 0
  def toggle_light(0), do: 1

  @spec get_target_cells(coordinate_pair(), coordinate_pair()) :: any()
  def get_target_cells({a_x, a_y}, {b_x, b_y}) do
    Enum.map(a_x..b_x, fn coord_x ->
      Enum.map(a_y..b_y, fn coord_y ->
        {coord_x, coord_y}
      end)
    end)
    |> List.flatten()
  end

  # turn off 199,133 through 461,193
  # toggle 322,558 through 977,958
  # toggle 537,781 through 687,941
  # turn on 226,196 through 599,390
  def process_instruction(grid, "turn off " <> range) do
    [corner_a, corner_b] =
      range
      |> parse_range()

    grid
    |> turn_off_lights(corner_a, corner_b)
  end

  def process_instruction(grid, "turn on " <> range) do
    [corner_a, corner_b] =
      range
      |> parse_range()

    grid
    |> turn_on_lights(corner_a, corner_b)
  end

  def process_instruction(grid, "toggle " <> range) do
    [corner_a, corner_b] =
      range
      |> parse_range()

    grid
    |> toggle_lights(corner_a, corner_b)
  end

  def parse_range(range_string) do
    range_string
    |> String.split(" through ")
    |> Enum.map(fn coord_pair ->
      [x, y] =
        coord_pair
        |> String.split(",")
        |> Enum.map(fn coord ->
          {int, ""} = Integer.parse(coord)
          int
        end)

      {x, y}
    end)
  end

  def part_1() do
    instructions = Aoc.FileReader.get_lines("lib/day6/puzzleInput.txt")
    grid = build_grid(1000, 1000)

    instructions
    |> Enum.reduce(grid, fn instruction, acc_grid ->
      process_instruction(acc_grid, instruction)
    end)
    |> Matrix.to_list()
    |> List.flatten()
    |> Stream.filter(fn light -> light == 1 end)
    |> Enum.count()
  end
end

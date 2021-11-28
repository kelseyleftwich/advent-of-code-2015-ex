defmodule Aoc.Day9 do
  require Formulae.Combinators

  def part_1(path \\ "lib/day9/sample.txt") do
    distance_dict =
      Aoc.FileReader.get_lines(path)
      |> get_distance_dict()

    distance_dict
    |> get_permutations()
    |> get_distance_for_routes(distance_dict)
    |> get_shortest_route()
    |> Map.get(:distance)
  end

  def part_2(path \\ "lib/day9/sample.txt") do
    distance_dict =
      Aoc.FileReader.get_lines(path)
      |> get_distance_dict()

    distance_dict
    |> get_permutations()
    |> get_distance_for_routes(distance_dict)
    |> get_longest_route()
    |> Map.get(:distance)
  end

  def get_longest_route(routes_with_distance) do
    routes_with_distance
    |> Enum.reduce(nil, fn
      %{distance: _, visited: _} = route, nil ->
        route

      %{distance: distance_current, visited: _} = route,
      %{distance: distance_longest_so_far, visited: _} = longest_so_far ->
        distance_current
        |> Kernel.>(distance_longest_so_far)
        |> if do
          route
        else
          longest_so_far
        end
    end)
  end

  def get_shortest_route(routes_with_distance) do
    routes_with_distance
    |> Enum.reduce(nil, fn
      %{distance: _, visited: _} = route, nil ->
        route

      %{distance: distance_current, visited: _} = route,
      %{distance: distance_shortest_so_far, visited: _} = shortest_so_far ->
        distance_current
        |> Kernel.<(distance_shortest_so_far)
        |> if do
          route
        else
          shortest_so_far
        end
    end)
  end

  def get_distance_for_routes(routes, distance_dict) do
    routes
    |> Enum.map(fn route_locations ->
      get_distance_for_route(route_locations, distance_dict)
    end)
  end

  def get_distance_for_route(route_locations, distance_dict) do
    route_locations
    |> Enum.reduce(
      %{visited: [], distance: 0},
      fn
        current_location, %{visited: [], distance: 0} ->
          %{visited: [current_location], distance: 0}

        current_location, %{visited: visited, distance: distance} ->
          [last | _] = visited
          leg_distance = distance_dict[last][current_location]
          %{visited: [current_location | visited], distance: distance + leg_distance}
      end
    )
  end

  def get_permutations(distance_dict) do
    locations =
      distance_dict
      |> Map.keys()

    with n <- locations |> Enum.count(), do: Formulae.permutations(locations, n)
  end

  def get_distance_dict(input_lines) do
    input_lines
    |> Enum.reduce(%{}, fn line, acc ->
      [origin, "to", destination, "=", distance] = String.split(line)

      {distance, ""} = Integer.parse(distance, 10)

      acc
      |> add_location_distance(origin, destination, distance)
      |> add_location_distance(destination, origin, distance)
    end)
  end

  def add_location_distance(distance_dict, loc_start, loc_end, distance) do
    distance_dict
    |> Map.update(loc_start, %{loc_end => distance}, fn prev ->
      prev |> Map.put(loc_end, distance)
    end)
  end
end

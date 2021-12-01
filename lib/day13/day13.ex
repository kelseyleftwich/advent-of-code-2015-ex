defmodule Day13 do
  def solve() do
    preferences =
      Aoc.FileReader.get_lines("lib/day13/puzzleInput.txt")
      |> Enum.map(&parse_line(&1))

    preferences
    |> get_distinct_people()
    |> List.insert_at(0, "me")
    |> get_permutations()
    |> Enum.map(&get_permutation_score(&1, preferences))
    |> Enum.max()
  end

  def get_permutation_score(persons, preferences) do
    persons_index_max = persons |> Enum.count() |> Kernel.-(1)

    0..persons_index_max
    |> Enum.reduce(0, fn index, points_tally ->
      primary_person = persons |> Enum.at(index)

      left_person =
        persons
        |> Enum.at(index - 1)

      right_index =
        index
        |> Kernel.+(1)
        |> rem(persons_index_max + 1)

      right_person = persons |> Enum.at(right_index)

      left_score =
        preferences
        |> get_preference(primary_person, left_person)

      right_score =
        preferences
        |> get_preference(primary_person, right_person)

      points_tally
      |> add_score(left_score)
      |> add_score(right_score)
    end)
  end

  def add_score(tally, {amount, :gain}), do: tally + amount
  def add_score(tally, {amount, :lose}), do: tally - amount

  def get_preference(preferences, primary_person, secondary_person) do
    {primary_person, secondary_person}

    {_, amount, type, _} =
      preferences
      |> Enum.find(
        {primary_person, "0", :gain, "me"},
        fn {primary, _, _, secondary} ->
          primary == primary_person and secondary == secondary_person
        end
      )

    {amount, ""} = Integer.parse(amount, 10)

    {amount, type}
  end

  def get_permutations(people) do
    with n <- people |> Enum.count(), do: Formulae.permutations(people, n)
  end

  def get_distinct_people(preferences) do
    preferences
    |> Enum.map(fn {person, _, _, _} ->
      person
    end)
    |> Enum.uniq()
  end

  def parse_line(line) when is_binary(line) do
    line
    |> String.replace(".", "")
    |> String.split(" ")
    |> parse_line()
  end

  # Alice would gain 54 happiness units by sitting next to Bob.
  def parse_line([
        primary_person,
        "would",
        "gain",
        amount,
        "happiness",
        "units",
        "by",
        "sitting",
        "next",
        "to",
        secondary_person
      ]) do
    {primary_person, amount, :gain, secondary_person}
  end

  # Alice would lose 79 happiness units by sitting next to Carol.
  def parse_line([
        primary_person,
        "would",
        "lose",
        amount,
        "happiness",
        "units",
        "by",
        "sitting",
        "next",
        "to",
        secondary_person
      ]) do
    {primary_person, amount, :lose, secondary_person}
  end
end

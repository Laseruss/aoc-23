defmodule Parse do
  def part1_parse(path) do
    numbers =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [_ | numbers] = String.split(line, " ", trim: true)
        Enum.map(numbers, &String.to_integer(&1))
      end)

    Enum.zip(numbers)
  end

  def part2_parse(path) do
    [time, distance] =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [_ | numbers] = String.split(line, " ", trim: true)

        Enum.reduce(numbers, "", fn number, acc -> acc <> number end)
        |> String.to_integer()
      end)

    {time, distance}
  end
end

defmodule Helpers do
  def find_first(pressed, max_time, _) when pressed > max_time, do: 0

  def find_first(pressed, max_time, distance_needed) do
    if pressed * (max_time - pressed) > distance_needed do
      pressed
    else
      find_first(pressed + 1, max_time, distance_needed)
    end
  end

  def find_last(pressed, _, _) when pressed < 0, do: 0

  def find_last(pressed, max_time, distance_needed) do
    if pressed * (max_time - pressed) > distance_needed do
      pressed
    else
      find_last(pressed - 1, max_time, distance_needed)
    end
  end
end

defmodule Part1 do
  def solve do
    Parse.part1_parse("input/day6.txt")
    |> Enum.reduce(1, fn {time, distance}, acc ->
      first_possible = Helpers.find_first(0, time, distance)
      last_possible = Helpers.find_last(time, time, distance)

      acc * (last_possible - first_possible + 1)
    end)
  end
end

defmodule Part2 do
  def solve do
    {time, distance} = Parse.part2_parse("input/day6.txt")

    first_possible = Helpers.find_first(0, time, distance)
    last_possible = Helpers.find_last(time, time, distance)

    last_possible - first_possible + 1
  end
end

IO.puts(Part2.solve())

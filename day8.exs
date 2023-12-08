defmodule Parse do
  def parse(path) do
    [directions, moves] =
      File.read!(path)
      |> String.split("\n\n", trim: true)

    moves =
      String.split(moves, "\n", trim: true)

    directions_list = String.to_charlist(directions)

    moves_map =
      moves
      |> Enum.reduce(%{}, fn move, acc ->
        [location, next] = String.split(move, " =", trim: true)
        next_location = String.slice(next, 2..(String.length(next) - 2))
        [left, right] = String.split(next_location, ", ", trim: true)

        Map.put(acc, location, {left, right})
      end)

    {directions_list, moves_map}
  end
end

defmodule Part1 do
  def solve() do
    {directions, moves} = Parse.parse("input/day8.txt")
    walk("AAA", directions, directions, moves, 0)
  end

  defp walk("ZZZ", _, _, _, steps), do: steps

  defp walk(current, [], direction_list, moves, steps) do
    walk(current, direction_list, direction_list, moves, steps)
  end

  defp walk(current, [next_direction | rest], direction_list, moves, steps) do
    if next_direction == ?L do
      {next, _} = Map.get(moves, current)
      walk(next, rest, direction_list, moves, steps + 1)
    else
      {_, next} = Map.get(moves, current)
      walk(next, rest, direction_list, moves, steps + 1)
    end
  end
end

defmodule Part2 do
  def solve() do
    {directions, moves} = Parse.parse("input/day8.txt")
    starting_points = find_starting_points(moves)

    Enum.map(starting_points, fn start -> walk(start, directions, directions, moves, 0) end)
    |> lcm_of_result()
  end

  defp walk(<<_, _, ?Z>>, _, _, _, steps), do: steps

  defp walk(current, [], direction_list, moves, steps) do
    walk(current, direction_list, direction_list, moves, steps)
  end

  defp walk(current, [next_direction | rest], direction_list, moves, steps) do
    if next_direction == ?L do
      {next, _} = Map.get(moves, current)
      walk(next, rest, direction_list, moves, steps + 1)
    else
      {_, next} = Map.get(moves, current)
      walk(next, rest, direction_list, moves, steps + 1)
    end
  end

  defp find_starting_points(moves) do
    Map.keys(moves)
    |> Enum.filter(&String.ends_with?(&1, "A"))
  end

  defp lcm_of_result([first, second | rest]) do
    lcm = BasicMath.lcm(first, second)

    Enum.reduce(rest, lcm, fn next, acc -> BasicMath.lcm(next, acc) end)
  end
end

defmodule BasicMath do
  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(trunc(a), trunc(b)))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: a * b / gcd(a, b)
end

IO.inspect(Part2.solve())

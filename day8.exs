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

IO.puts(Part1.solve())

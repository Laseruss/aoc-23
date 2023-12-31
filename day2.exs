defmodule Day02 do
  def part1 do
    Part1.solve()
  end

  def part2 do
    Part2.solve()
  end
end

defmodule Parse do
  def parse(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ":", trim: true))
    |> Enum.map(fn [game, rounds] ->
      [_, game_num] = String.split(game)
      stones = String.split(rounds, [";", ","], trim: true)

      stones =
        Enum.map(stones, fn set ->
          [stones, color] = String.split(set)
          {color, String.to_integer(stones)}
        end)

      {String.to_integer(game_num), stones}
    end)
  end
end

defmodule Part1 do
  def solve do
    Parse.parse("input/day2.txt")
    |> Enum.filter(fn {game, rounds} ->
      Enum.all?(rounds, &check(&1))
    end)
    |> Enum.sum()
  end

  defp check({"red", x}) when x > 12, do: false
  defp check({"green", x}) when x > 13, do: false
  defp check({"blue", x}) when x > 14, do: false
  defp check(_), do: true
end

defmodule Part2 do
  def solve do
    Parse.parse("input/day2.txt")
    |> Enum.map(fn {_, rounds} ->
      Enum.reduce(rounds, %{"red" => 0, "green" => 0, "blue" => 0}, &update_min_values(&1, &2))
    end)
    |> Enum.reduce(0, fn %{"red" => red, "green" => green, "blue" => blue}, acc ->
      acc + red * green * blue
    end)
  end

  defp update_min_values({color, num}, acc) do
    if num > Map.get(acc, color) do
      Map.replace!(acc, color, num)
    else
      acc
    end
  end
end

defmodule Parse do
  def parse(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1))
    |> Enum.map(fn line -> Enum.map(line, &String.to_integer(&1)) end)
  end
end

defmodule Helpers do
  def get_next_line([], next), do: Enum.reverse(next)

  def get_next_line([[x, y] | rest], next) do
    get_next_line(rest, [y - x | next])
  end
end

defmodule Part1 do
  def solve do
    Parse.parse("input/day9.txt")
    |> Enum.reduce(0, fn row, acc ->
      acc + calculate_next(row)
    end)
  end

  defp calculate_next(row) do
    if(Enum.all?(row, fn n -> n == 0 end)) do
      0
    else
      tail = List.last(row)
      pairs = Enum.chunk_every(row, 2, 1, :discard)
      next_line = Helpers.get_next_line(pairs, [])

      tail + calculate_next(next_line)
    end
  end
end

defmodule Part2 do
  def solve do
    Parse.parse("input/day9.txt")
    |> Enum.reduce(0, fn row, acc ->
      acc + calculate(row)
    end)
  end

  defp calculate([first | _] = row) do
    if(Enum.all?(row, fn n -> n == 0 end)) do
      0
    else
      pairs = Enum.chunk_every(row, 2, 1, :discard)
      next_line = Helpers.get_next_line(pairs, [])
      first - calculate(next_line)
    end
  end
end

IO.puts(Part2.solve())

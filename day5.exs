defmodule Parse do
  def parse(path) do
    [seeds | transforms] =
      File.read!(path)
      |> String.split("\n\n")

    [_ | seed_values] = String.split(seeds, [":", " "], trim: true)
    seed_values = Enum.map(seed_values, &String.to_integer(&1))

    transforms =
      Enum.map(transforms, fn transform ->
        [_ | ranges] = String.split(transform, "\n", trim: true)

        Enum.map(ranges, fn range ->
          [start, new, steps] =
            String.split(range, " ", trim: true)
            |> Enum.map(&String.to_integer(&1))

          {new, start, steps}
        end)
      end)

    {seed_values, transforms}
  end
end

defmodule Part1 do
  def solve do
    {seeds, transforms} = Parse.parse("input/day5.txt")

    Enum.map(seeds, &find_location(&1, transforms))
    |> Enum.min()
  end

  defp find_location(seed, []) do
    seed
  end

  defp find_location(seed, {start, new, steps}) do
    if seed >= start and seed < start + steps do
      seed - start + new
    else
      seed
    end
  end

  defp find_location(seed, [{start, new, steps} | rest_current]) do
    if seed >= start and seed < start + steps do
      seed - start + new
    else
      find_location(seed, rest_current)
    end
  end

  defp find_location(seed, [[] | rest]) do
    find_location(seed, rest)
  end

  defp find_location(seed, [current_transform | rest]) do
    [{start, new, steps} | rest_current] = current_transform

    if seed >= start and seed < start + steps do
      find_location(seed - start + new, rest)
    else
      find_location(seed, [rest_current | rest])
    end
  end
end

IO.puts(Part1.solve())

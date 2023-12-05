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

defmodule Helpers do
  def find_location(seed, []) do
    seed
  end

  def find_location(seed, {start, new, steps}) do
    if seed >= start and seed < start + steps do
      seed - start + new
    else
      seed
    end
  end

  def find_location(seed, [{start, new, steps} | rest_current]) do
    if seed >= start and seed < start + steps do
      seed - start + new
    else
      find_location(seed, rest_current)
    end
  end

  def find_location(seed, [[] | rest]) do
    find_location(seed, rest)
  end

  def find_location(seed, [current_transform | rest]) do
    [{start, new, steps} | rest_current] = current_transform

    if seed >= start and seed < start + steps do
      find_location(seed - start + new, rest)
    else
      find_location(seed, [rest_current | rest])
    end
  end
end

defmodule Part1 do
  def solve do
    {seeds, transforms} = Parse.parse("input/day5.txt")

    Enum.map(seeds, &Helpers.find_location(&1, transforms))
    |> Enum.min()
  end
end

defmodule Part2 do
  def solve() do
    {seeds, transforms} = Parse.parse("input/day5.txt")
    seeds = Enum.chunk_every(seeds, 2)

    transforms =
      Enum.map(transforms, fn transform ->
        Enum.map(transform, fn {start, new, steps} -> {new, start, steps} end)
      end)
      |> Enum.reverse()

    find_first(0, transforms, seeds)
  end

  defp find_first(curr, transforms, seeds) do
    starting_num = Helpers.find_location(curr, transforms)

    found =
      Enum.any?(seeds, fn [start, length] ->
        starting_num >= start and starting_num < start + length
      end)

    if found do
      curr
    else
      find_first(curr + 1, transforms, seeds)
    end
  end
end

IO.puts(Part2.solve())

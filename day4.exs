defmodule Parse do
  def parse(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, numbers] = String.split(line, ":", trim: true)

      [winning_numbers, your_numbers] =
        String.split(numbers, "|", trim: true)
        |> Enum.map(fn nums ->
          String.split(nums)
          |> Enum.map(&String.to_integer(&1))
        end)

      {winning_numbers, your_numbers}
    end)
  end
end

defmodule Part1 do
  def solve do
    games = Parse.parse("input/day4.txt")

    Enum.reduce(games, 0, fn {winning_numbers, ticket_numbers}, acc ->
      acc +
        Enum.reduce(
          ticket_numbers,
          0,
          fn num, acc ->
            if Enum.member?(winning_numbers, num) do
              if acc == 0 do
                1
              else
                acc * 2
              end
            else
              acc
            end
          end
        )
    end)
  end
end

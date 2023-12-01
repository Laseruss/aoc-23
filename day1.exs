defmodule Part1 do
  def solve(path) do
    File.stream!(path)
    |> Enum.map(fn line ->
      for <<byte <- line>>, byte >= ?0 and byte <= ?9, do: byte
    end)
    |> Enum.map(fn num_str ->
      String.to_integer(<<List.first(num_str), List.last(num_str)>>)
    end)
    |> Enum.sum()
  end
end

defmodule Part2 do
  @nums [
    {"one", 1},
    {"two", 2},
    {"three", 3},
    {"four", 4},
    {"five", 5},
    {"six", 6},
    {"seven", 7},
    {"eight", 8},
    {"nine", 9}
  ]

  def solve(input) do
    input
    |> File.stream!()
    |> Enum.map(&find_occurences(&1, []))
    |> Enum.map(fn row_nums ->
      List.first(row_nums) * 10 + List.last(row_nums)
    end)
    |> Enum.sum()
  end

  defp find_occurences(<<>>, accum), do: Enum.reverse(accum)

  defp find_occurences(<<head, rest::binary>> = line, accum) do
    if head >= ?0 and head <= ?9 do
      find_occurences(rest, [String.to_integer(<<head>>) | accum])
    else
      val =
        Enum.find_value(@nums, nil, fn {num_str, num} ->
          if String.slice(line, 0..(String.length(num_str) - 1)) == num_str do
            num
          end
        end)

      case val do
        nil -> find_occurences(rest, accum)
        x -> find_occurences(rest, [x | accum])
      end
    end
  end
end

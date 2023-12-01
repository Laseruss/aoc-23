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
    {"one", "1"},
    {"two", "2"},
    {"three", "3"},
    {"four", "4"},
    {"five", "5"},
    {"six", "6"},
    {"seven", "7"},
    {"eight", "8"},
    {"nine", "9"}
  ]

  def solve() do
    File.stream!("input/day1.txt")
    |> Enum.map(fn line -> find_first(line) <> find_last(String.reverse(line)) end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp find_last(line, accum \\ <<>>)
  defp find_last(<<head, _::binary>>, _) when head >= ?0 and head <= ?9, do: <<head>>

  defp find_last(<<head, rest::binary>>, accum) do
    accum = <<head>> <> accum

    val =
      Enum.find_value(@nums, nil, fn {num_str, num} ->
        if String.starts_with?(accum, num_str) do
          num
        end
      end)

    case val do
      nil -> find_last(rest, accum)
      x -> x
    end
  end

  defp find_first(<<head, _::binary>>) when head >= ?0 and head <= ?9, do: <<head>>

  defp find_first(<<_, rest::binary>> = line) do
    val =
      Enum.find_value(@nums, nil, fn {num_str, num} ->
        if String.starts_with?(line, num_str) do
          num
        end
      end)

    case val do
      nil -> find_first(rest)
      x -> x
    end
  end
end

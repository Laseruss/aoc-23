defmodule Parse do
  def parse do
    File.read!("input/day3.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end
end

defmodule Helpers do
  def get_symbols(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce([], fn {row, idx}, acc ->
      check_row(row, idx, 0, []) ++ acc
    end)
    |> Enum.reverse()
  end

  defp check_row([], _, _, acc), do: acc

  defp check_row([head | tail], row_idx, col_idx, acc) do
    if !is_digit(head) and head != "." do
      check_row(tail, row_idx, col_idx + 1, [{row_idx, col_idx} | acc])
    else
      check_row(tail, row_idx, col_idx + 1, acc)
    end
  end

  def is_digit(char), do: char >= "0" and char <= "9"

  def get_numbers(input, symbols) do
    input
    |> Enum.with_index()
    |> Enum.reduce([], fn {row, idx}, acc ->
      next = find_numbers(row, symbols, idx, 0, false, 0, 0)
      [next | acc]
    end)
  end

  defp find_numbers([], _, _, _, is_valid_part, curr, total) do
    if is_valid_part do
      total + curr
    else
      total
    end
  end

  defp find_numbers([head | tail], symbols, row_idx, col_idx, is_valid_part, curr, total) do
    if is_digit(head) do
      valid_part =
        if is_valid_part do
          true
        else
          found = Enum.find(symbols, nil, &check_valid_part(&1, row_idx, col_idx))

          if found != nil do
            true
          else
            false
          end
        end

      find_numbers(
        tail,
        symbols,
        row_idx,
        col_idx + 1,
        valid_part,
        curr * 10 + String.to_integer(head),
        total
      )
    else
      new_total =
        if is_valid_part do
          curr + total
        else
          total
        end

      find_numbers(
        tail,
        symbols,
        row_idx,
        col_idx + 1,
        false,
        0,
        new_total
      )
    end
  end

  def check_valid_part(symbol, row_idx, col_idx) do
    up = row_idx - 1
    down = row_idx + 1
    left = col_idx - 1
    right = col_idx + 1

    case symbol do
      {^up, ^left} -> true
      {^up, ^col_idx} -> true
      {^up, ^right} -> true
      {^row_idx, ^left} -> true
      {^row_idx, ^right} -> true
      {^down, ^left} -> true
      {^down, ^col_idx} -> true
      {^down, ^right} -> true
      _ -> false
    end
  end
end

defmodule Part1 do
  def solve() do
    input = Parse.parse()
    symbols = Helpers.get_symbols(input)

    Helpers.get_numbers(input, symbols)
    |> Enum.sum()
  end
end

defmodule Part2 do
  # find all the asterisks
  # go over the input and find numbers
  # somehow multiply the number with the sum of the current asterisk
  # and keep track of how many numbers connect each asterisk
  # sum the asterisks that connects two numbers
  def solve() do
    input = Parse.parse()
    asterisks = get_asterisks(input)

    numbers =
      input
      |> Enum.with_index()
      |> Enum.reduce(asterisks, fn {row, i}, acc -> get_numbers(row, acc, i, 0, 0, nil) end)
      |> Map.values()
      |> Enum.reduce(0, fn {total, neighbors}, acc ->
        if neighbors == 2 do
          acc + total
        else
          acc
        end
      end)

    numbers
  end

  defp get_asterisks(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, idx}, acc ->
      check_row(row, acc, idx, 0)
    end)
  end

  defp get_numbers([], gears, _, _, curr, gear) do
    if gear == nil do
      gears
    else
      {total, neighbors} = Map.get(gears, gear)
      Map.put(gears, gear, {total * curr, neighbors + 1})
    end
  end

  defp get_numbers([head | tail], gears, row, col, curr, gear) do
    if Helpers.is_digit(head) do
      gear =
        if gear == nil do
          Map.keys(gears)
          |> Enum.find(&Helpers.check_valid_part(&1, row, col))
        else
          gear
        end

      curr = curr * 10 + String.to_integer(head)

      get_numbers(tail, gears, row, col + 1, curr, gear)
    else
      if gear == nil do
        get_numbers(tail, gears, row, col + 1, 0, gear)
      else
        {total, neighbors} = Map.get(gears, gear)
        gears = Map.put(gears, gear, {total * curr, neighbors + 1})
        get_numbers(tail, gears, row, col + 1, 0, nil)
      end
    end
  end

  defp check_row([], acc, _, _), do: acc

  defp check_row([head | tail], acc, row, column) do
    if head == "*" do
      acc = Map.put(acc, {row, column}, {1, 0})
      check_row(tail, acc, row, column + 1)
    else
      check_row(tail, acc, row, column + 1)
    end
  end
end

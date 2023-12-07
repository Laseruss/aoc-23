defmodule Parse do
  def parse(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      [hand, bid] = String.split(row, " ", trim: true)
      bid = String.to_integer(bid)
      cards = String.graphemes(hand)

      {cards, bid}
    end)
  end
end

defmodule Helpers do
  def rank_hand(hand) do
    case hand do
      :no_pair -> 0
      :one_pair -> 1
      :two_pair -> 2
      :three_of_a_kind -> 3
      :full_house -> 4
      :four_of_a_kind -> 5
      :five_of_a_kind -> 6
    end
  end
end

defmodule Part1 do
  def solve do
    input =
      Parse.parse("input/day7.txt")
      |> Enum.map(fn {cards, bid} ->
        unique_cards =
          Enum.frequencies(cards)

        num_unique =
          unique_cards
          |> Map.keys()
          |> Enum.count()

        max_unique =
          unique_cards
          |> Map.values()
          |> Enum.max()

        hand =
          case(num_unique) do
            5 -> :no_pair
            4 -> :one_pair
            3 when max_unique == 2 -> :two_pair
            3 -> :three_of_a_kind
            2 when max_unique == 3 -> :full_house
            2 -> :four_of_a_kind
            1 -> :five_of_a_kind
          end

        {cards, hand, bid}
      end)

    sorted_hands =
      Enum.sort(input, fn {l_cards, l_hand, _}, {r_cards, r_hand, _} ->
        l_hand = Helpers.rank_hand(l_hand)
        r_hand = Helpers.rank_hand(r_hand)

        cond do
          l_hand > r_hand -> false
          l_hand < r_hand -> true
          true -> compare_cards(l_cards, r_cards)
        end
      end)

    Enum.with_index(sorted_hands, 1)
    |> Enum.reduce(0, fn {{_, _, bid}, rank}, acc -> acc + bid * rank end)
  end

  defp compare_cards([l_card | l_rest], [r_card | r_rest]) do
    l_card = map_card(l_card)
    r_card = map_card(r_card)

    cond do
      l_card > r_card -> false
      l_card < r_card -> true
      true -> compare_cards(l_rest, r_rest)
    end
  end

  defp map_card(card) do
    case card do
      "T" -> "A"
      "J" -> "B"
      "Q" -> "C"
      "K" -> "D"
      "A" -> "E"
      _ -> card
    end
  end
end

defmodule Part2 do
  def solve() do
    input =
      Parse.parse("input/day7.txt")
      |> Enum.map(fn {cards, bid} ->
        card_frequencies = Enum.frequencies(cards)
        {jokers, card_frequencies} = Map.pop(card_frequencies, "J", 0)

        if card_frequencies == %{} do
          {cards, :five_of_a_kind, bid}
        else
          [{first_card, first_occ}] =
            Map.to_list(card_frequencies)
            |> Enum.sort(fn {l_card, l_occ}, {r_card, r_occ} ->
              l_occ > r_occ
            end)
            |> Enum.take(1)

          card_frequencies = Map.put(card_frequencies, first_card, first_occ + jokers)

          num_unique =
            card_frequencies
            |> Map.keys()
            |> Enum.count()

          max_unique =
            card_frequencies
            |> Map.values()
            |> Enum.max()

          hand =
            case(num_unique) do
              5 -> :no_pair
              4 -> :one_pair
              3 when max_unique == 2 -> :two_pair
              3 -> :three_of_a_kind
              2 when max_unique == 3 -> :full_house
              2 -> :four_of_a_kind
              1 -> :five_of_a_kind
            end

          {cards, hand, bid}
        end
      end)

    sorted_hands =
      Enum.sort(input, fn {l_cards, l_hand, _}, {r_cards, r_hand, _} ->
        l_hand = Helpers.rank_hand(l_hand)
        r_hand = Helpers.rank_hand(r_hand)

        cond do
          l_hand > r_hand -> false
          l_hand < r_hand -> true
          true -> compare_cards(l_cards, r_cards)
        end
      end)

    Enum.with_index(sorted_hands, 1)
    |> Enum.reduce(0, fn {{_, _, bid}, rank}, acc -> acc + bid * rank end)
  end

  defp compare_cards([l_card | l_rest], [r_card | r_rest]) do
    l_card = map_card(l_card)
    r_card = map_card(r_card)

    cond do
      l_card > r_card -> false
      l_card < r_card -> true
      true -> compare_cards(l_rest, r_rest)
    end
  end

  defp map_card(card) do
    case card do
      "T" -> "A"
      "J" -> "0"
      "Q" -> "C"
      "K" -> "D"
      "A" -> "E"
      _ -> card
    end
  end
end

IO.inspect(Part2.solve())

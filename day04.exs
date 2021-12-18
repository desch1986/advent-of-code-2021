defmodule Day04 do
  def part1(path) do
    [numbers | bingos] = path
      |> File.read!()
      |> String.split("\r\n\r\n", trim: true)

    numbers = numbers
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    bingos = bingos
      |> Enum.map(fn bingo ->
        bingo
        |> String.split(~r/\s+/, trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    numbers
    |> Enum.reduce_while([], fn elem, acc ->
      matches = [elem | acc]

      case Enum.find(bingos, &win(&1, matches)) do
        nil -> {:cont, matches}
        bingo -> {:halt, Enum.sum(not_matched(bingo, matches)) * elem}
      end
    end)
  end

  def part2(path) do
    [numbers | bingos] = path
      |> File.read!()
      |> String.split("\r\n\r\n", trim: true)

    numbers = numbers
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    bingos = bingos
      |> Enum.map(fn bingo ->
        bingo
        |> String.split(~r/\s+/, trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    numbers
    |> Enum.reduce_while({bingos, []}, fn elem, {bingos, acc} ->
      matches = [elem | acc]

      case bingos do
        [bingo] ->
          if win(bingo, matches) do
            {:halt, Enum.sum(not_matched(bingo, matches)) * elem}
          else
            {:cont, {bingos, matches}}
          end

        _ ->
          {:cont, {Enum.reject(bingos, &win(&1, matches)), matches}}
      end
    end)
  end

  defp win(
    [
      a1, a2, a3, a4, a5,
      b1, b2, b3, b4, b5,
      c1, c2, c3, c4, c5,
      d1, d2, d3, d4, d5,
      e1, e2, e3, e4, e5
    ],
    numbers) do
    all_in([a1, a2, a3, a4, a5], numbers) or
    all_in([b1, b3, b3, b4, b5], numbers) or
    all_in([c1, c2, c3, c4, c5], numbers) or
    all_in([d1, d2, d3, d4, d5], numbers) or
    all_in([e1, e2, e3, e4, e5], numbers) or
    all_in([a1, b1, c1, d1, e1], numbers) or
    all_in([a2, b2, c2, d2, e2], numbers) or
    all_in([a3, b3, c3, d3, e3], numbers) or
    all_in([a4, b4, c4, d4, e4], numbers) or
    all_in([a5, b5, c5, d5, e5], numbers) or
    all_in([a1, b2, c3, d4, e5], numbers) or
    all_in([a5, b4, c3, d2, e1], numbers)
  end

  defp not_matched(bingo, numbers) do
    Enum.reject(bingo, &(&1 in numbers))
  end

  defp all_in(list, numbers) do
    Enum.all?(list, &(&1 in numbers))
  end
end
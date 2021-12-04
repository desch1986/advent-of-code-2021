defmodule Day03 do

  # Shared code

  defp count(list) do
    Enum.reduce(list, List.duplicate(0, 12), fn input, acc ->
      for {value, counter} <- Enum.zip(input, acc) do
        case value do
          ?1 -> counter + 1
          ?0 -> counter
        end
      end
    end)
  end

  defp loadData(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_charlist/1)
  end

  # Code for Part 1

  def task1(path) do
    data = 
      path
      |> loadData

    halfSize = div(length(data), 2)

    {a, b} =
      data
      |> count()
      |> Enum.reduce({0, 0}, fn elem, {a, b} ->
        if elem > halfSize do
          {a * 2 + 1, b * 2}
        else
          {a * 2, b * 2 + 1}
        end
      end)
    a * b
  end

  # Code for Part 2

  # Hopefully coming soon...

end

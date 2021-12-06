defmodule Day06 do

  def start(path, days) do
    path
    |> File.read!
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies
    |> next_day(days)
    |> Map.values
    |> Enum.sum
  end

  defp next_day(population, 0), do: population

  defp next_day(population, days) do
    start = population
    |> Map.get(0, 0)

    population
    |> Enum.filter(fn {days, _} -> days > 0 end)
    |> Enum.map(fn {days, k} -> {days-1, k} end)
    |> Map.new
    |> Map.update(6, start, fn callback -> callback + start end)
    |> Map.put(8, start)
    |> next_day(days-1)
  end

end

defmodule Day07 do

  def part1(path) do
    path
    |> readFile
    |> then(fn l ->
      min = Enum.min(l)
      max = Enum.max(l)
      Enum.map(min..max, fn col -> l |> Enum.map(&abs(col - &1)) |> Enum.sum() end)
    end)
    |> Enum.min()
  end

  def part2(path) do
    triangle_number = fn n -> n * (n + 1) / 2 end

    path
    |> readFile
    |> then(fn l ->
      min = Enum.min(l)
      max = Enum.max(l)
      Enum.map(min..max, fn col -> l |> Enum.map(&triangle_number.(abs(col - &1))) |> Enum.sum() end)
    end)
    |> Enum.min()
  end

  defp readFile(path) do
    path
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
  
end
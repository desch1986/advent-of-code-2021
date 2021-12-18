defmodule Day09 do
  def part1(path) do
    grid = path
    |> parse

    Enum.reduce(grid, 0, fn {coord, height}, score ->
      if is_low?(coord, height, grid) do
        score + 1 + height
      else
        score
      end
    end)
  end

  def part2(path) do
    grid = path
    |>parse

    grid
    |> Enum.group_by(fn {coord, height} -> end_point(coord, height, grid) end)
    |> Map.delete(nil)
    |> Enum.sort_by(fn {_coord, points} -> length(points) end, :desc)
    |> Enum.take(3)
    |> Enum.reduce(1, fn {_coord, points}, acc -> acc * length(points) end)
  end

  defp parse(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end)
    |> map_grid()
  end

  defp map_grid(list_of_lists, y \\ 0, acc \\ %{})

  defp map_grid([], _, acc), do: acc

  defp map_grid([row | rest], y, acc) do
    acc = map_row(row, 0, y, acc)
    map_grid(rest, y + 1, acc)
  end

  defp map_row([], _, _, acc), do: acc

  defp map_row([h | t], x, y, acc) do
    acc = Map.put(acc, {x, y}, h)
    map_row(t, x + 1, y, acc)
  end 

  defp is_low?(coord, current, map) do
    coord
    |> neighbors()
    |> Enum.map(&Map.get(map, &1, 10))
    |> Enum.all?(fn height -> height > current end)
  end  

  defp end_point({x, y}, current, map) do
    cond do
      current == 9 ->
        nil

      is_low?({x, y}, current, map) ->
        {x, y}

      :otherwise ->
        next = lowest_neighbor({x, y}, map)
        end_point(next, map[next], map)
    end
  end

  defp lowest_neighbor(coord, map) do
    coord
    |> neighbors()
    |> Enum.map(&{&1, Map.get(map, &1, 10)})
    |> Enum.min_by(fn {_coord, height} -> height end)
    |> elem(0)
  end

  defp neighbors({x, y}) do
    [{x, y - 1}, {x, y + 1}, {x - 1, y}, {x + 1, y}]
  end
end
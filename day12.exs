defmodule Day12 do
  def part1(path) do
    path
    |> File.read!
    |> String.split("\n", trim: true)
    |> parse
    |> find_path1("start", [])
    |> List.flatten()
    |> Enum.count(&(&1 == "end"))
  end

  def part2(path) do
    path
    |> File.read!
    |> String.split("\r\n", trim: true)
    |> find_path2("start", [], true)
    |> List.flatten()
    |> Enum.count(&(&1 == "end"))
  end

  defp parse(lines) do
    caves = lines 
    |> Enum.map(&String.split(&1, "-", trim: true))

    caves
    |> Enum.map(&Enum.reverse/1)
    |> Enum.concat(caves)
    |> Enum.group_by(&Enum.at(&1, 0), &Enum.at(&1, 1))
  end

  defp find_path1(_, "end", visited), do: ["end" | visited]
  defp find_path1(map, current_cave, visited) do
    map
    |> Map.get(current_cave)
    |> Enum.filter(fn cave -> 
      cave == String.upcase(cave) || cave not in visited 
    end)
    |> Enum.map(fn cave ->
      find_path1(map, cave, [current_cave | visited])
    end)
  end

  defp find_path2(_, "end", visited, _), do: ["end" | visited]
  defp find_path2(_, "start", [_|_] = visited, _), do: visited
  defp find_path2(map, current_cave, visited, small) do
    small =
      cond do
        small == false -> false
        current_cave == String.downcase(current_cave) && current_cave in visited -> false
        true -> true
      end

    map
    |> Map.get(current_cave)
    |> Enum.filter(fn cave -> 
      small || cave == String.upcase(cave) || cave not in visited 
    end)
    |> Enum.map(fn cave ->
      find_path2(map, cave, [current_cave | visited], small)
    end)
  end  
end
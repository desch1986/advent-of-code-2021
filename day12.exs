defmodule Day12 do
  def part1(path) do
    path
    |> parse()
    |> find_paths(false)
  end

  def part2(path) do
    path
    |> parse()
    |> find_paths(true)
  end

  defp find_paths(connections, visit_twice, position \\ "start", visited \\ MapSet.new())
  defp find_paths(_, _, "end", _), do: 1
  defp find_paths(connections, visit_twice, position, visited) do
    neighbors = Map.get(connections, position, [])

    neighbors
    |> Enum.reject(&(&1 == "start"))
    |> Enum.map(fn neighbor ->
      cond do
        is_small_cave(neighbor) and neighbor in visited and visit_twice ->
          find_paths(connections, false, neighbor, MapSet.put(visited, position))

        is_small_cave(neighbor) and neighbor in visited ->
          0

        true ->
          find_paths(
            connections,
            visit_twice,
            neighbor,
            MapSet.put(visited, position)
          )
      end
    end)
    |> Enum.sum()
  end

  defp is_small_cave(cave), do: cave == String.downcase(cave)

  defp parse(path) do
    input = path
    |> File.read!
    for row <- String.split(input, "\r\n", trim: true),
        [from, to] = String.split(row, "-", parts: 2),
        reduce: %{} do
      connections ->
        connections
        |> Map.update(from, [to], fn dests -> [to | dests] end)
        |> Map.update(to, [from], fn dests -> [from | dests] end)
    end
  end
end
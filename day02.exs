commands =
  input
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, " "))

# Part 1
{x, y} =
  Enum.reduce(
    commands,
    {0, 0},
    fn [direction, steps], {horizontal, depth} ->
      steps = String.to_integer(steps)

      case direction do
        "forward" -> {horizontal + steps, depth}
        "down" -> {horizontal, depth + steps}
        "up" -> {horizontal, depth - steps}
      end
    end
  )
IO.puts(x * y)

# Part 2
{x, y, _z} =
  Enum.reduce(
    commands,
    {0, 0, 0},
    fn [direction, steps], {horizontal, depth, aim} ->
      steps = String.to_integer(steps)

      case direction do
        "forward" -> {horizontal + steps, depth + aim * steps, aim}
        "down" -> {horizontal, depth, aim + steps}
        "up" -> {horizontal, depth, aim - steps}
      end
    end
  )
IO.puts(x * y)
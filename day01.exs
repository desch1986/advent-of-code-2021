# Part 1
IO.puts input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2, 1, :discard) 
    |> Enum.count(fn [prev, curr] -> curr > prev end) 

# Part 2
IO.puts input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(3, 1, :discard) 
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard) 
    |> Enum.count(fn [prev, curr] -> curr > prev end) 
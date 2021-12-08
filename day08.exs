defmodule Day08 do

  def part1(path) do
    # Segments, which identify digits directly:
    # ('1' = 2 segments, '7' = 3 segments, '4' = 4 segments, '8' = 7 segments)
    unique_segment_counts = [2, 3, 4, 7] 

    path
    |> read_file
    |> Enum.map(fn {_signals, digits} ->
      Enum.count(digits, fn digit -> 
        Enum.count(digit) in unique_segment_counts
      end)
    end)
    |> Enum.sum()
  end

  def part2(path) do
    input = path
      |> read_file

    Enum.map(input, fn {signals, digits} ->
      segments = [:a, :b, :c, :d, :e, :f, :g]

      # These digits can be identified directly by number of segments (see part 1)
      d1 = Enum.find(signals, &(Enum.count(&1) == 2))
      d4 = Enum.find(signals, &(Enum.count(&1) == 4))
      d7 = Enum.find(signals, &(Enum.count(&1) == 3))
      d8 = Enum.find(signals, &(Enum.count(&1) == 7))     

  	  # Two is the only digit without lower right segment (f)
      f = Enum.find(segments, fn segment ->
        Enum.count(signals, fn signal ->
          MapSet.member?(signal, segment)
        end) == 9
      end)      
      d2 = Enum.find(signals, &(MapSet.member?(&1, f) == false))
      
      # Six is an eight without the upper right segment
      [c] = Enum.to_list(MapSet.delete(d1, f))      
      d6 = MapSet.delete(d8, c)

      # Zero is an eight without the segment in the middle.
      [b] = d8
        |> MapSet.difference(d2)
        |> MapSet.delete(f)
        |> MapSet.to_list()
      [d] = d4
        |> MapSet.difference(d1)
        |> MapSet.delete(b)
        |> MapSet.to_list()
      d0 = MapSet.delete(d8, d)

      # Candidates for nine (especially containing lower right segment)
      [d9] = signals
        |> Enum.filter(&(&1 not in [d0, d1, d2, d4, d6, d7, d8]))
        |> Enum.filter(&(Enum.count(&1) == 6))

      # Three is a two with lower right instead of lower left segment 
      [e] = d8
        |> MapSet.difference(d9)
        |> MapSet.to_list()
      d3 = d2
        |> MapSet.delete(e)
        |> MapSet.put(f)

      # Five is an eight without upper right and lower left segment
      d5 = d8
        |> MapSet.delete(c)
        |> MapSet.delete(e)

      digits
      |> Enum.map(fn digit -> 
        id_to_digit = %{d0 => 0, d1 => 1, d2 => 2, d3 => 3, d4 => 4, d5 => 5, d6 => 6, d7 => 7, d8 => 8, d9 => 9}
        id_to_digit[digit] end)
      |> Enum.join()
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  defp read_file(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [signals, digits] = String.split(line, "|", trim: true)
      {
        create_sets(signals),
        create_sets(digits)
      }
    end)
  end

  defp create_sets(input) do
    input
    |> String.split()
    |> Enum.map(&create_set/1)
  end

  defp create_set(input) do
    input
    |> String.split("", trim: true)
    |> Enum.map(&String.to_atom/1)
    |> MapSet.new()
  end

end
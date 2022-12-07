defmodule AOC2022.Day6 do
  import AOC2022.InputReader

  def find_first_start_of_packet_marker(min_chars) do
    parsed_input()
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce_while({-1, []}, fn {char, i}, {_, buffer} ->
      buffer = Enum.slice([char | buffer], 0..(min_chars - 1))

      if Enum.count(buffer) >= min_chars && Enum.uniq(buffer) == buffer do
        {:halt, {i, buffer}}
      else
        {:cont, {i, buffer}}
      end
    end)
  end
  
  def are_all_chars_unique(buffer) do
    
  end

  def parsed_input do
    input("day6")
  end
end
defmodule AOC2022.Day6 do
  import AOC2022.InputReader

  def get_first_start_of_packet_marker do
    parsed_input()
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce_while({-1, []}, fn {char, i}, {_, buffer} ->
      new_buffer = [char | buffer]
      IO.inspect(new_buffer)
      new_buffer = Enum.slice(new_buffer, 0..13)

      if Enum.count(new_buffer) >= 14 && are_all_chars_unique(new_buffer) do
        {:halt, {i, new_buffer}}
      else
        {:cont, {i, new_buffer}}
      end
    end)
  end
  
  def are_all_chars_unique(buffer) do
    Enum.uniq(buffer) == buffer
  end

  def parsed_input do
    input("day6")
  end
end
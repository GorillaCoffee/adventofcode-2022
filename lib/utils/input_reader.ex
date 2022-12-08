defmodule AOC2022.InputReader do
  import File

  def to_number(str) do
    {number, _} = Integer.parse(str)

    number
  end

  def input(file_name) do
    {:ok, input} = "~/rumandcode/AdventOfCode/aoc2022/inputs"
    |> Path.expand()
    |> (fn path -> File.read("#{path}/#{file_name}.txt") end).()

    input
  end
end
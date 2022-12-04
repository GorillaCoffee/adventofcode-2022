defmodule AOC2022.Day1 do
  import AOC2022.InputReader

  def elf_carrying_most_calories do
    input("day1")
    |> String.split("\n\n")
    |> Enum.reduce(0, fn elf_calories, highest_calories ->
      elf_calories
      |> String.split("\n")
      |> Enum.reject(&Kernel.==(&1, ""))
      |> Enum.map(fn calorie_str ->
        IO.inspect(calorie_str)
        {calorie, _} = Integer.parse(calorie_str)
        calorie
      end)
      |> Enum.sum()
      |> Kernel.max(highest_calories)
    end)
  end
end
defmodule AOC2022.Day1 do
  import AOC2022.InputReader

  def highest_amount_of_calories_carried_by_one_elf do
    elves_calories
    |> Enum.map(&Enum.sum/1)
    |> Enum.reduce(fn elf_total_calories, highest_calories ->
      max(elf_total_calories, highest_calories)
    end)
  end

  def highest_amount_of_calories_carried_by_top_3_elves do
    elves_calories
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.slice(0..2)
    |> Enum.sum()
  end

  def elves_calories do
    input("day1")
    |> String.split("\n\n")
    |> Enum.map(fn calories ->
      calories
      |> String.split("\n")
      |> Enum.reject(&Kernel.==(&1, ""))
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(&Kernel.elem(&1, 0))
    end)
  end
end
defmodule AOC2022.Day3 do
  import AOC2022.InputReader

  def sum_of_priorities_for_rutsacks do
    rutsacks
    |> Enum.map(&common_item_type_in_rutsack_compartments/1)
    |> Enum.map(&priority_for_item_type/1)
    |> Enum.sum()
  end

  def sum_of_priorities_for_each_three_elf_group do
    rutsacks
    |> Enum.chunk_every(3)
    |> Enum.map(&common_item_type_in_group_of_rutsacks/1)
    |> Enum.map(&priority_for_item_type/1)
    |> Enum.sum()
  end

  def priority_for_item_type(item_type) do
    char_binary = :binary.first(item_type)

    if char_binary > 96 do
      char_binary - 96
    else
      char_binary - 38
    end
  end

  def common_item_type_in_group_of_rutsacks(rutsack_group) do
    [rutsack_a, rutsack_b, rutsack_c] = rutsack_group

    rutsack_a
    |> String.graphemes()
    |> Enum.find(fn item ->
      is_item_in_compartment(item, rutsack_b) && is_item_in_compartment(item, rutsack_c)
    end)
  end

  def common_item_type_in_rutsack_compartments(rutsack) do
    {compartment_a, compartment_b} = rutsack_compartments(rutsack)

    compartment_a
    |> String.graphemes()
    |> Enum.find(&is_item_in_compartment(&1, compartment_b))
  end

  def is_item_in_compartment(item, compartment) do
    result = compartment
    |> String.graphemes()
    |> Enum.find(&Kernel.==(&1, item))

    result != nil
  end

  def rutsack_compartments(rutsack) do
    rutsack_length = round(String.length(rutsack) / 2)

    String.split(rutsack, ~r/.{#{rutsack_length}}/, include_captures: true, trim: true)
    |> List.to_tuple()
  end

  def rutsacks do
    input("day3")
    |> String.split("\n")
    |> Enum.reject(&Kernel.==(&1, ""))
  end

end

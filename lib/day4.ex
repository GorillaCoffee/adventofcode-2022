defmodule AOC2022.Day4 do
  import AOC2022.InputReader

  def nb_of_assignment_pairs_that_fully_contain_one_another() do
    parsed_input
    |> Enum.map(&input_row_to_list_of_integers/1)
    |> Enum.map(&does_one_range_contain_another/1)
    |> Enum.reject(&Kernel.==(&1, false))
    |> Enum.count()
  end

  def does_one_range_contain_another([range_1, range_2]) do
    IO.inspect("huh")
    IO.inspect(range_1)
    IO.inspect(range_2)

    range_1_str = Enum.join(range_1)
    range_2_str = Enum.join(range_2)

    range_1_str =~ range_2_str || range_2_str =~ range_1_str
  end

  def input_row_to_list_of_integers(row_str) do
    row_str
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.map(fn range_str ->
      IO.inspect(range_str)

      [start_nb, end_nb] = range_str |> Enum.map(&to_number/1)

      :lists.seq(start_nb, end_nb, 1)
    end)
  end

  def parsed_input do
    input("day4")
    |> String.split("\n")
    |> Enum.reject(&Kernel.==(&1, ""))
  end
end
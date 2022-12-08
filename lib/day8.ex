defmodule AOC2022.Day8 do
  import AOC2022.InputReader
  
  def answer do
    forest()
    |> compute_visibility()
  end
  
  def compute_visibility(forest) do
    forest
    |> Enum.map(&compute_row_visibility(&1, forest))
  end
  
  def compute_row_visibility({tree_row, row_i}, forest) do
    tree_row
    |> Enum.map(fn {tree_height, col_i} ->
      result = %{height: tree_height, visible: is_visible(tree_height, row_i, col_i, forest)}
      
      Map.get(result, :visible)
    end)
  end
  
  def is_visible(tree_height, row, col, forest) when row == 0 or col == 0, do: true
  
  def is_visible(tree_height, row, col, forest) do
    cond do
      row == Enum.count(forest) - 1 ->
        true
      col == (forest |> Enum.at(0) |> forest_row_length()) - 1 ->
        true
      true ->
        false
    end
  end
  
  def forest_row_length({tree_row, row_i}), do: Enum.count(tree_row) 
  
  def is_visible(tree, row, col, forest) do
    false
  end
  
  def forest do
    input("day8")
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn tree_row ->
      tree_row
      |> Enum.map(&to_number/1)
      |> Enum.with_index()
    end)
    |> Enum.with_index()
  end
end
defmodule AOC2022.Day8 do
  import AOC2022.InputReader
  
  def answer_1 do
    forest()
    |> compute_visibility()
  end
  
  def answer_2 do
    forest()
    |> compute_scenic_score()
  end
  
  def compute_visibility(forest) do
    forest
    |> Enum.map(&compute_row_visibility(&1, forest))
    |> Enum.sum()
  end
  
  def compute_scenic_score(forest) do
    forest
    |> Enum.map(&compute_row_scenic_score(&1, forest))
    |> Enum.sort(:desc)
    |> List.first()
  end
  
  def compute_row_visibility({tree_row, row_i}, forest) do
    tree_row
    |> Enum.filter(fn {tree_height, col_i} ->
      is_visible(tree_height, row_i, col_i, forest)
    end)
    |> Enum.count()
  end
  
  def compute_row_scenic_score({tree_row, row_i}, forest) do
    tree_row
    |> Enum.map(fn {tree_height, col_i} ->
       scenic_score(tree_height, row_i, col_i, forest)  
    end)
    |> Enum.sort(:desc)
    |> List.first()
  end  
  
  def scenic_score(tree_height, row, col, forest) do
    scenic_score_top(tree_height, row, col, forest)
    * scenic_score_left(tree_height, row, col, forest)
    * scenic_score_bottom(tree_height, row, col, forest)
    * scenic_score_right(tree_height, row, col, forest)
  end

  def is_visible(tree_height, row, col, forest) when row == 0 or col == 0, do: true
  
  def is_visible(tree_height, row, col, forest) do
    cond do
      row == Enum.count(forest) - 1
      || col == (forest |> Enum.at(0) |> forest_row_length()) - 1
      || is_visible_from_top(tree_height, row, col, forest) 
      || is_visible_from_bottom(tree_height, row, col, forest)
      || is_visible_from_left(tree_height, row, col, forest)
      || is_visible_from_right(tree_height, row, col, forest) ->
        true
      true ->
        false
    end
  end

  def scenic_score_top(tree_height, row, col, forest) do
    (0..row - 1)
    |> Enum.reverse()
    |> Enum.reduce_while(0, fn row, score ->
      scenic_score_direction(tree_height, row, col, forest, score)
    end)
  end

  def scenic_score_left(tree_height, row, col, forest) do
    (0..col - 1)
    |> Enum.reverse()
    |> Enum.reduce_while(0, fn col, score ->
      scenic_score_direction(tree_height, row, col, forest, score)
    end)
  end

  def scenic_score_bottom(tree_height, row, col, forest) do
    (row + 1..forest_row_length(forest) - 1)
    |> Enum.reduce_while(0, fn row, score ->
      scenic_score_direction(tree_height, row, col, forest, score)
    end)
  end

  def scenic_score_right(tree_height, row, col, forest) do
    (col + 1..Enum.count(forest) - 1)
    |> Enum.reduce_while(0, fn col, score ->
      scenic_score_direction(tree_height, row, col, forest, score)  
    end)
  end
  
  def scenic_score_direction(tree_height, row, col, forest, score) do
    if tree_height > get_tree_height(forest, row, col) do
      {:cont, score + 1}
    else
      {:halt, score + 1}
    end
  end
  
  def is_visible_from_top(tree_height, row, col, forest) do
    (0..max(Enum.count(forest), row - 1))
    |> Enum.all?(fn row ->
      tree_height > get_tree_height(forest, row, col)
    end)
  end
  
  def is_visible_from_left(tree_height, row, col, forest) do
    (0..max(Enum.count(forest), col - 1))
    |> Enum.all?(fn col ->
      tree_height > get_tree_height(forest, row, col)
    end)
  end
  
  def is_visible_from_right(tree_height, row, col, forest) do
    (col + Enum.count(forest) - 1)
    |> Enum.all?(fn col ->
      tree_height > get_tree_height(forest, row, col)
    end)
  end
  
  def is_visible_from_bottom(tree_height, row, col, forest) do
    (row + 1..forest_row_length(forest) - 1)
    |> Enum.all?(fn row ->
      tree_height > get_tree_height(forest, row, col)
    end)
  end
  
  def get_tree_height(forest, row, col) do
    forest_col_length = Enum.count(forest)

    case Enum.at(forest, row) do
      {tree_row, row_i} ->
        case Enum.at(tree_row, col) do
          {tree_height, col_i} ->
            tree_height
          nil -> 
            0
        end
      nil ->
        0
    end
  end
  
  def forest_row_length({tree_row, row_i}), do: Enum.count(tree_row) 
  
  def forest_row_length(forest), do: forest |> Enum.at(0) |> forest_row_length()
  
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
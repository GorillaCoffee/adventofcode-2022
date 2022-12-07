defmodule AOC2022.Day5 do
  import AOC2022.InputReader

  def answer_1() do
    initial_state()
    |> apply_moves(moves(), :cratemover_9000)
  end
  
  def answer_2() do
    initial_state()
    |> apply_moves(moves(), :cratemover_9001)
  end

  def moves() do
    moves_input()
    |> Enum.map(&parse_move_line/1)
    |> Enum.map(&List.to_tuple/1)
  end

  def initial_state() do
    initial_state_input()
    |> Enum.map(&parse_state_line/1)
    |> transpose()
    |> Enum.map(fn column -> 
      Enum.reject(column, &Kernel.==(&1, " "))
    end)
    |> Enum.with_index()
    |> Enum.map(fn {column, index} ->
      {index, column}
    end)
    |> Enum.into(%{})
  end

  def apply_moves(state, moves, cratemover_mk) do
    IO.inspect(state)
    IO.gets("Begin")

    moves
    |> Enum.reduce(state, fn {count, from, to}, state ->
      apply_move(to_number(count), to_number(from), to_number(to), state, cratemover_mk)
    end)
  end

  def apply_move(count, from, to, columns, :cratemover_9001) do
    from_i = from - 1
    to_i = to - 1
    
    IO.inspect(columns)
    column_from = Map.get(columns, from_i)
    column_to = Map.get(columns, to_i) || []
    
    crates_being_moved = Enum.slice(column_from, 0..(count - 1))
    column_from = Enum.drop(column_from, count)
    column_to = crates_being_moved ++ column_to

    columns
              |> Map.put(from_i, column_from)
              |> Map.put(to_i, column_to)
  end 
  
  def apply_move(count, from, to, columns, :cratemover_9000) do
    Enum.reduce(0..(count - 1), columns, fn _, columns ->
      from_i = from - 1
      to_i = to - 1
      column_from = Map.get(columns, from_i)
      column_to = Map.get(columns, to_i) || []
      
      case column_from do
        [crate | column_from] ->
          column_to = [crate | column_to]

          columns = columns
          |> Map.put(from_i, column_from)
          |> Map.put(to_i, column_to)
        _ ->
          columns
      end
    end)
  end

  def parse_move_line(line) do
    line
    |> String.replace("move ", "")
    |> String.replace(" from ", ",")
    |> String.replace(" to ", ",")
    |> String.split(",")
  end
  def parse_state_line(line) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {crate, index} ->
      0 == rem(index + 3, 4)
    end)
    |> Enum.map(fn {crate, _} -> crate end)
  end

  def moves_input do
    input("day5")
    |> String.split("\n")
    |> Enum.reject(&Kernel.==(&1, ""))
  end

  def initial_state_input do
    input("day5-2")
    |> String.split("\n")
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def to_number(str) do
    {number, _} = Integer.parse(str)

    number
  end
  
  def render_state(state) do
    state
    |> Enum.map(fn {index, column} ->
      {index, Enum.reverse(column)}
    end)
    |> IO.inspect()
  end
end
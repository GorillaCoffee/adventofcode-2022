defmodule AOC2022.Day7 do
  import AOC2022.InputReader
  
  def answer_1() do
    file_tree()
    |> Map.get(:tree)
    |> total_dir_size()
  end

  def total_dir_size(tree, dir_to_delete \\ %{dir_name: nil, size: 999999999}) when is_map(tree) do
    tree
    |> Enum.to_list()
    |> Enum.reduce({0, dir_to_delete}, fn {dir_name, value}, {total_dir_size, dir_to_delete} ->
      case value do
        tree when is_map(tree) ->
          {dir_size, %{dir_name: dir_to_delete_name, size: dir_to_delete_size} = dir_to_delete} = total_dir_size(tree, dir_to_delete)
          
          if dir_size >= 8381165 && dir_size < dir_to_delete_size do
            {dir_size + total_dir_size, %{dir_name: dir_name, size: dir_size}}
          else
            {dir_size + total_dir_size, dir_to_delete}
          end
        value ->
          {value + total_dir_size, dir_to_delete}
      end
    end)
  end
  
  def dir_size(tree) when is_map(tree) do
    tree
    |> Enum.to_list()
    |> Enum.reduce(0, fn {_, value}, total ->
      case value do
        tree when is_map(tree) ->
          dir_size(tree) + total
        value ->
          value + total
      end
    end)
  end
  
  def dir_size(_), do: 0
  
  def file_tree do
    parsed_input()
    |> Enum.map(&String.split(&1, " "))
    |> Enum.reduce(%{path: [], tree: %{}, sum: 0}, fn action, %{path: path, tree: tree} = state ->
      case action do
        ["dir" | _] ->
          state
        ["$" | command] ->
          execute(state, command)
        [file_size, file_name] ->
          result = state
          |> add_file_size(file_size)
          |> save_file(file_name, file_size)
      end
    end)
  end
  
  def add_file_size(%{path: path, sum: sum} = state, file_size) do
    Map.put(state, :sum, sum + to_number(file_size))
  end

  def add_file_size(state, _) do
    state
  end
  
  def save_file(%{tree: tree, path: path} = state, file_name, file_size) do
    state
    |> Map.put(:tree, save_file(tree, Enum.reverse(path), file_name, file_size))
  end
  
  def save_file(tree, [dir_name | path], file_name, file_size) do
    dir = Map.get(tree, dir_name, %{})

    tree
    |> Map.put(dir_name, save_file(dir, path, file_name, file_size))
  end
  
  def save_file(tree, [dir_name], file_name, file_size) do
    dir = Map.get(tree, dir_name, %{})

    Map.put(tree, dir_name, save_file(dir, [], file_name, file_size))
  end
  
  def save_file(dir, [], file_name, file_size) do
    Map.put_new(dir, file_name, to_number(file_size))
  end
  
  def cache(tree, [], _, _), do: tree

  def execute(state, ["cd", "/"]) do
    Map.put(state, :path, [])
  end
  
  def execute(%{path: path} = state, ["cd", ".."]) do
    IO.inspect("before")
    IO.inspect(path)
    case path do
      [] ->
        state
      [_ | parent_path] ->
        IO.inspect("after")
        IO.inspect(parent_path)
        Map.put(state, :path, parent_path)
    end
  end

  def execute(%{path: path} = state, ["cd", directory]) do
    Map.put(state, :path, [directory | path])
  end

  def execute(state, ["ls"]) do
    state
  end
  
  def parsed_input do
    input("day7")
    |> String.split("\n")
  end
  
end
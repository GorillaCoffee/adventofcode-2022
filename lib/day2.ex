defmodule AOC2022.Day2 do
  import AOC2022.InputReader

  @interpretations [
    :shape_vs_shape,
    :shape_vs_outcome
  ]

  def calculate_total_score(interpretation) do
    parsed_input()
    |> Enum.map(&calculate_round_points(&1, interpretation))
    |> Enum.sum()
  end

  def calculate_round_points({column_a, column_b}, :shape_vs_shape = strategy) do
    opponent_shape = map_column_a(column_a)
    your_shape = map_column_b(column_b, strategy)

    outcome = outcome_for_shapes(opponent_shape, your_shape)

    calculate_round_points(your_shape, outcome)
  end

  def calculate_round_points({column_a, column_b}, :shape_vs_outcome = strategy) do
    opponent_shape = map_column_a(column_a)
    outcome = map_column_b(column_b, strategy)

    your_shape = your_shape_for_interaction(opponent_shape, outcome)

    calculate_round_points(your_shape, outcome)
  end

  def calculate_round_points(your_shape, outcome) do
    points_for_outcome(outcome) + points_for_drawn_shape(your_shape)
  end

  @drawn_shape_points %{
    rock: 1,
    paper: 2,
    scissors: 3
  }
  def points_for_drawn_shape(shape) do
    Map.get(@drawn_shape_points, shape)
  end

  @outcome_points %{
    win: 6,
    draw: 3,
    lose: 0
  }
  def points_for_outcome(outcome) do
    Map.get(@outcome_points, outcome)
  end

  @shape_numerical_power %{
    rock: 0,
    paper: 1,
    scissors: 2
  }
  def outcome_for_shapes(opponent_shape, your_shape) do
    opponent_shape_power = Map.get(@shape_numerical_power, opponent_shape)
    your_shape_power = Map.get(@shape_numerical_power, your_shape)

    cond do
      opponent_shape_power == your_shape_power ->
        :draw
      opponent_shape_power == rem(your_shape_power + 1, 3) ->
        :lose
      true ->
        :win
    end
  end

  def your_shape_for_interaction(opponent_shape, outcome) do
    opponent_shape_power = Map.get(@shape_numerical_power, opponent_shape)
    numerical_power_shape = for {shape, power} <- @shape_numerical_power, into: %{}, do: {power, shape}

    your_shape_power = case outcome do
      :draw ->
        opponent_shape_power
      :win ->
        rem(opponent_shape_power + 1, 3)
      :lose ->
        rem(opponent_shape_power + 2, 3)
    end

    Map.get(numerical_power_shape, your_shape_power)
  end

  @opponent_shapes %{
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors
  }
  def map_column_a(opponent_char) do
    case Map.get(@opponent_shapes, opponent_char) do
      nil ->
        raise "unexpected char #{opponent_char} for opponent's drawn char"
      shape ->
        shape
    end
  end

  @your_shapes %{
    "X" => :rock,
    "Y" => :paper,
    "Z" => :scissors
  }
  def map_column_b(your_char, :shape_vs_shape) do
    case Map.get(@your_shapes, your_char) do
      nil ->
        raise "unexpected char #{your_char} for your drawn char"
      shape ->
        shape
    end
  end

  @your_outcomes %{
    "X" => :lose,
    "Y" => :draw,
    "Z" => :win
  }
  def map_column_b(outcome_char, :shape_vs_outcome) do
    case Map.get(@your_outcomes, outcome_char) do
      nil ->
        raise "unexpected char #{outcome_char} for your outcome char"
      shape ->
        shape
    end
  end

  def parsed_input() do
    input("day2")
    |> String.split("\n")
    |> Enum.reject(&Kernel.==(&1, ""))
    |> Enum.map(fn round_str ->
      round_str
      |> String.split(" ")
      |> Enum.slice(0..1)
      |> List.to_tuple()
    end)
  end

end
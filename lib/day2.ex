defmodule AOC2022.Day2 do
  import AOC2022.InputReader

  def calculate_total_score() do
    input("day2")
    |> String.split("\n")
    |> Enum.reject(&Kernel.==(&1, ""))
    |> Enum.map(fn round_str ->
      round_str
      |> String.split(" ")
      |> Enum.slice(0..1)
      |> List.to_tuple()
      |> calculate_round_points()
    end)
    |> Enum.sum()
  end

  def calculate_round_points({opponent_choice_char, your_choice_char}) do
    calculate_round_points(opponent_choice_char, your_choice_char)
  end

  def calculate_round_points(opponent_choice_char, your_choice_char) do
    opponent_shape = map_opponent_shape(opponent_choice_char)
    your_shape = map_your_shape(your_choice_char)

    interaction_outcome(opponent_shape, your_shape)
    |> points_for_outcome()
    |> Kernel.+(points_for_drawn_choice(your_shape))
  end

  @drawn_choice_points %{
    rock: 1,
    paper: 2,
    scissors: 3
  }
  def points_for_drawn_choice(choice) do
    Map.get(@drawn_choice_points, choice)
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
  def interaction_outcome(opponent_shape, your_shape) do
    opponent_choice_power = Map.get(@shape_numerical_power, opponent_shape)
    your_choice_power = Map.get(@shape_numerical_power, your_shape)

    cond do
      opponent_choice_power == your_choice_power ->
        :draw
      opponent_choice_power == rem(your_choice_power + 1, 3) ->
        :lose
      true ->
        :win
    end
  end

  @opponent_shapes %{
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors
  }
  def map_opponent_shape(opponent_char) do
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
  def map_your_shape(your_char) do
    case Map.get(@your_shapes, your_char) do
      nil ->
        raise "unexpected char #{your_char} for your drawn char"
      shape ->
        shape
    end
  end

end
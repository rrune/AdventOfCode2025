defmodule Day04 do
  def get_surroundings(symbol_map, row, col) do
    deltas = [
      {-1, -1}, {-1, 0}, {-1, 1},
      {0, -1},          {0, 1},
      {1, -1},  {1, 0}, {1, 1}
    ]

    Enum.reduce(deltas, 0, fn {delta_row, delta_col}, acc ->
      if Map.get(symbol_map, {row + delta_row, col + delta_col}) == "@", do: acc + 1, else: acc
    end)
  end

  def get_accessible_rolls(symbol_map) do
    Enum.reduce(symbol_map, {symbol_map, 0}, fn {{row, col}, _}, {new_map, acc} ->
        if get_surroundings(symbol_map, row, col) < 4,
          do: {Map.delete(new_map, {row, col}), acc + 1},
          else: {new_map, acc}
    end)
  end

  def get_accessible_rolls_rec(symbol_map, total) do
    {new_map, accessible} = get_accessible_rolls(symbol_map)

    if accessible == 0,
      do: total,
      else: get_accessible_rolls_rec(new_map, total + accessible)
  end
end

symbol_map =
  "input.txt"
  |> File.read!()
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.graphemes/1)
  |> Enum.with_index()
  |> Enum.map(fn {r, i} ->
    r
    |> Enum.with_index()
    |> Enum.filter(fn {c, _} -> c == "@" end)
    |> Enum.map(fn {c, i2} ->
      {{i, i2}, c}
    end)
  end)
  |> List.flatten()
  |> Map.new()

# Part 1
Day04.get_accessible_rolls(symbol_map)
|> elem(1)
|> IO.inspect()

# Part 2
Day04.get_accessible_rolls_rec(symbol_map, 0)
|> IO.inspect()

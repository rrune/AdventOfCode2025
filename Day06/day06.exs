defmodule Day06 do
  def split_at_indexes(string, indexes) do
    ranges =
      [0 | indexes]
      |> Enum.zip(indexes ++ [String.length(string)])
      |> Enum.map(fn {from, to} -> {from, to - from} end)

    Enum.map(ranges, fn {start, len} ->
      String.slice(string, start, len)
    end)
    |> Enum.filter(&(&1 != ""))
  end
end

input =
  "input.txt"
  |> File.read!()
  |> String.trim()
  |> String.split("\n")

# part 1
input
|> Enum.map(fn line ->
  line
  |> String.split(" ")
  |> Enum.filter(fn e -> e != "" end)
end)
|> Enum.zip()
|> Enum.map(&Tuple.to_list/1)
|> Enum.reduce(0, fn row, acc ->
  acc +
    case List.last(row) do
      "*" ->
        Enum.filter(row, &(&1 != "*"))
        |> Enum.map(&String.to_integer/1)
        |> Enum.reduce(1, fn e, a -> e * a end)

      "+" ->
        Enum.filter(row, &(&1 != "+"))
        |> Enum.map(&String.to_integer/1)
        |> Enum.sum()
    end
end)
|> IO.inspect()

op_list =
  input
  |> Enum.map(fn line ->
    line
    |> String.split("")
  end)
  |> List.last()
  |> Enum.with_index()
  |> Enum.filter(fn c ->
    elem(c, 0) == "+" || elem(c, 0) == "*"
  end)
  |> Enum.map(&elem(&1, 1))
  |> Enum.map(&(&1 - 1))

# part 2
input
|> Enum.map(fn r ->
  r
  |> Day06.split_at_indexes(op_list)
end)
|> Enum.zip()
|> Enum.map(&Tuple.to_list/1)
|> then(fn rows ->
  Enum.map(rows, fn r ->
    if r == List.last(rows) do
      r
    else
      Enum.map(r, fn c ->
        String.slice(c, 0, String.length(c) - 1)
      end)
    end
  end)
end)
|> Enum.reduce(0, fn row, acc ->
  {op, nums} =
    row
    |> Enum.reverse()
    |> then(fn [h | t] -> {String.trim(h), Enum.reverse(t)} end)

  trans_nums =
    nums
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(fn tuple -> Tuple.to_list(tuple) |> Enum.join("") end)

  acc +
    case op do
      "*" ->
        trans_nums
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)
        |> Enum.reduce(1, fn e, a -> e * a end)

      "+" ->
        trans_nums
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)
        |> Enum.sum()
    end
end)
|> IO.inspect()

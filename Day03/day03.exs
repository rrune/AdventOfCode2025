defmodule Day03 do
  def getMax(l) do
    l
    |> Enum.with_index()
    |> Enum.reduce({-1, -1}, fn {k, i}, {num, index} ->
      if k > num, do: {k, i}, else: {num, index}
    end)
  end

  def getNum(_, acc, 0) do
    acc
    |> String.to_integer()
  end

  def getNum(str, acc, remaining) do
    {num, index} =
      str
      |> String.codepoints()
      |> Enum.split(String.length(str) - remaining + 1)
      |> then(fn {l, _} -> l end)
      |> Enum.map(&String.to_integer(&1))
      |> getMax()

    {_, right} = String.split_at(str, index + 1)

    getNum(right, acc <> Integer.to_string(num), remaining - 1)
  end
end

"input.txt"
|> File.read!()
|> String.trim()
|> String.split("\n")
|> Enum.reduce({0, 0}, fn line, {part1, part2} ->
  {part1 + Day03.getNum(line, "", 2), part2 + Day03.getNum(line, "", 12)}
end)
|> IO.inspect()

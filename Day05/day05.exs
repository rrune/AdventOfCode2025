defmodule Day05 do
  def resolve_overlap([], acc) do
    acc
  end

  def resolve_overlap([cur | rest], []) do
    resolve_overlap(rest, [cur])
  end

  def resolve_overlap([{s, e} | rest], [{ps, pe} | acc_rest] = acc) do
    cond do
      s <= pe + 1 -> resolve_overlap(rest, [{ps, max(e, pe)} | acc_rest])
      true -> resolve_overlap(rest, [{s,e} | acc])
    end
  end
end

[ranges, ingres_str] =
  "input.txt"
  |> File.read!()
  |> String.trim()
  |> String.split("\n\n")
  |> Enum.map(&String.split(&1, "\n"))

ingres =
  ingres_str
  |> Enum.map(&String.to_integer/1)

fresh =
  ranges
  |> Enum.map(fn range ->
    range
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
    |> then(&{List.first(&1), List.last(&1)})
  end)

# part 1
Enum.reduce(ingres, 0, fn ingre, acc ->
  if Enum.any?(fresh, fn {s, e} ->
       s <= ingre && ingre <= e
     end), do: acc + 1, else: acc
end)
|> IO.inspect()

# part 2
fresh
|> Enum.sort_by(&elem(&1, 0))
|> Day05.resolve_overlap([])
|> Enum.reduce(0, fn {first, last}, acc ->
  acc + (last - first) + 1
end)
|> IO.inspect()

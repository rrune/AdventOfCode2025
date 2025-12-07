input =
  "input.txt"
  |> File.read!()
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.graphemes/1)

s_index =
  input
  |> List.first()
  |> Enum.with_index()
  |> Enum.reduce([], fn {c, i}, acc ->
    if "S" == c do
      acc ++ [i]
    else
      acc
    end
  end)

Enum.reduce(input, {%{List.first(s_index) => 1}, 0}, fn row, {mp, sp} ->
  Enum.reduce(mp, {%{}, sp}, fn {k, v}, {new_mp, splits} ->
    if Enum.at(row, k) == "^" do
      {new_mp |> Map.update(k - 1, v, fn old -> old + v end) |> Map.update(k + 1, v, fn old -> old + v end), splits + 1}
    else
      {Map.update(new_mp, k, v, fn old -> old + v end), splits}
    end
  end)
end)
|> tap(fn e ->
  e
  |> elem(1)
  |> IO.inspect()
end)
|> elem(0)
|> Map.values()
|> Enum.sum()
|> IO.inspect()

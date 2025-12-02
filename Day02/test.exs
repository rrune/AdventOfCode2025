s = 3
str = Integer.to_string(s)

Enum.reduce(1..floor(String.length(str) / 2), 0, fn k, t ->
  m =
    str
    |> String.codepoints()
    |> Enum.chunk_every(k)
    |> Enum.uniq()
    |> length() == 1

    if m, do: t + s, else: t
end)
|> IO.puts()

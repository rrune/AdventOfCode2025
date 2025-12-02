defmodule Day02 do
  def findRepHigher(k, p) do
    cond do
      p < 1 -> -1
      String.slice(k, 0, p) == String.slice(k, p, p) -> p
      true -> findRepHigher(k, p - 1)
    end
  end

  def findRepLower(k, p) do
    cond do
      p > floor(String.length(k) / 2) -> -1
      String.slice(k, 0, p) == String.slice(k, p, p) -> p
      true -> findRepLower(k, p + 1)
    end
  end

  def validateReps(k, p) do
    if rem(String.length(k), p) != 0 do
      false
    else
      k
      |> String.codepoints()
      |> Enum.chunk_every(p)
      |> Enum.uniq()
      |> length() == 1
    end
  end
end

"input.txt"
|> File.read!()
|> String.trim()
|> String.split(",")
|> Enum.reduce(0, fn e, t ->
  [first, last] =
    e
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)

  t +
    Enum.reduce(first..last, 0, fn k, total ->
      str = Integer.to_string(k)
      {left, right} = String.split_at(str, floor(String.length(str) / 2))

      if left == right, do: total + k, else: total
    end)
end)
|> IO.puts()

# "input.txt"
# |> File.read!()
# |> String.trim()
# |> String.split(",")
# |> Enum.reduce(0, fn e, t ->
#  [first, last] =
#    e
#    |> String.split("-")
#    |> Enum.map(&String.to_integer/1)
#
#  t +
#    Enum.reduce(first..last, 0, fn s, total ->
#      str = Integer.to_string(s)
#
#      total +
#        Enum.reduce(1..floor(String.length(str) / 2), 0, fn k, t ->
#          IO.inspect({s, k})
#
#          m =
#            str
#            |> String.codepoints()
#            |> Enum.chunk_every(k)
#            |> Enum.uniq()
#            |> length() == 1
#
#          if m, do: t + s, else: t
#        end)
#    end)
# end)
# |> IO.puts()

"input.txt"
|> File.read!()
|> String.trim()
|> String.split(",")
|> Enum.reduce(0, fn e, t ->
  [first, last] =
    e
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)

  t +
    Enum.reduce(first..last, 0, fn k, total ->
      str = Integer.to_string(k)
      higher = Day02.findRepHigher(str, floor(String.length(str) / 2))
      lower = Day02.findRepLower(str, 1)

      cond do
        lower >= 0 and Day02.validateReps(str, lower) ->
          total + k

        higher >= 0 and Day02.validateReps(str, higher) ->
          total + k

        true ->
          total
      end
    end)
end)
|> IO.puts()

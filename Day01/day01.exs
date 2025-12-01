defmodule Day01 do
  def run([], _, {total_p1, total_p2}) do
    {total_p1, total_p2}
  end

  def run([{dir, num} | tail], pos, {total_p1, total_p2}) do
    d = if dir == "R", do: 1, else: -1
    new_pos = mod(pos + d * num, 100)

    run(
      tail,
      new_pos,
      {
        total_p1 + if(new_pos == 0, do: 1, else: 0), # part 1
        total_p2 + Enum.count(1..num, fn n -> (pos + d * n) |> mod(100) == 0 end) # part 2
      }
    )
  end

  def mod(n, m) do
    rem = rem(n, m)
    if rem < 0, do: rem + m, else: rem
  end
end

"input.txt"
|> File.read!()
|> String.trim()
|> String.split("\n")
|> Enum.map(fn line ->
  {dir, num} = String.split_at(line, 1)
  {dir, num |> String.to_integer()}
end)
|> Day01.run(50, {0, 0})
|> IO.inspect()

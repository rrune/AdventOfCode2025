defmodule Day08 do
  def add_next_con(left, right, setList) do
    {idl, idr} =
      Enum.reduce(Enum.with_index(setList), {-1, -1}, fn {set, id}, {idl, idr} ->
        idl = if MapSet.member?(set, left), do: id, else: idl
        idr = if MapSet.member?(set, right), do: id, else: idr
        {idl, idr}
      end)

    case {idl >= 0, idr >= 0} do
      {false, false} ->
        [MapSet.new([left, right]) | setList]

      {true, false} ->
        List.update_at(setList, idl, &MapSet.put(&1, right))

      {false, true} ->
        List.update_at(setList, idr, &MapSet.put(&1, left))

      {true, true} when idl != idr ->
        merged = MapSet.union(Enum.at(setList, idl), Enum.at(setList, idr))

        setList
        |> List.replace_at(idl, merged)
        |> List.delete_at(idr)

      _ ->
        setList
    end
  end
end

cords =
  "input.txt"
  |> File.read!()
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(fn line ->
    String.split(line, ",")
    |> Enum.map(&String.to_integer/1)
  end)

count = if length(cords) <= 20, do: 10, else: 1000

shortest_conn_list =
  Enum.reduce(cords, %{}, fn [x1, y1, z1], mp ->
    Enum.reduce(cords, mp, fn [x2, y2, z2], mp2 ->
      diff = floor(abs(:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2) + :math.pow(z2 - z1, 2)))

      if diff != 0 && !Map.has_key?(mp2, {[x2, y2, z2], [x1, y1, z1]}) do
        Map.put(mp2, {[x1, y1, z1], [x2, y2, z2]}, diff)
      else
        mp2
      end
    end)
  end)
  |> Map.to_list()
  |> Enum.sort(fn {_, diff1}, {_, diff2} -> diff1 <= diff2 end)

# part 1
shortest_conn_list
|> Enum.split(count)
|> elem(0)
|> Enum.reduce([], fn {{left, right}, _}, setList ->
  Day08.add_next_con(left, right, setList)
end)
|> Enum.sort(fn mp1, mp2 -> MapSet.size(mp1) >= MapSet.size(mp2) end)
|> Enum.split(3)
|> elem(0)
|> Enum.reduce(1, fn set, acc ->
  acc * MapSet.size(set)
end)
|> IO.inspect()

# part 2
shortest_conn_list
|> Enum.reduce_while([], fn {{left, right}, _}, setList ->
  new_setList = Day08.add_next_con(left, right, setList)

  if Enum.at(new_setList, 0) |> MapSet.size() == length(cords) do
    IO.inspect(Enum.at(left, 0) * Enum.at(right, 0))

    {:halt, new_setList}
  else
    {:cont, new_setList}
  end
end)

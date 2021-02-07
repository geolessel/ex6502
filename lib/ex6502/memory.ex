defmodule Ex6502.Memory do
  alias Ex6502.Computer
  use Bitwise

  @max_size 0xFFFF

  def init(size \\ @max_size) do
    0..(size - 1)
    |> Enum.map(fn _ -> 0 end)
  end

  def load(memory, location, values) do
    values
    |> ensure_all_are_8_bit()
    |> case do
      true ->
        values
        |> Enum.with_index()
        |> Enum.reduce(memory, fn {value, i}, acc ->
          List.replace_at(acc, location + i, value)
        end)

      {false, val} ->
        raise "#{val} doesn't fit into 8 bits"
    end
  end

  def set_reset_vector(m, address) do
    high = address >>> 8
    low = address &&& 0xFF
    load(m, 0xFFFC, [low, high])
  end

  def absolute(%Computer{address_bus: location, memory: memory} = c, index \\ 0) do
    Map.put(c, :data_bus, get(memory, location + index))
  end

  def indirect(%Computer{} = c, index \\ 0) do
    address =
      c.memory
      |> Computer.resolve_address(c.address_bus)

    c
    |> Map.put(:address_bus, address + index)
    |> absolute()
  end

  def get(memory, location) do
    Enum.at(memory, location)
  end

  def get(memory, location, amount) do
    Enum.slice(memory, location, amount)
  end

  def inspect(%Computer{memory: memory}, start_location, length) do
    0..(length - 1)
    |> Stream.chunk_every(16)
    |> Stream.map(fn [first | _] = line ->
      bytes =
        line
        |> Enum.map(fn offset ->
          :io_lib.format("~2.16.0B", [get(memory, start_location + offset)])
        end)
        |> Enum.join(" ")

      line =
        :io_lib.format("~4.16.0B | ", [start_location + first])
        |> IO.chardata_to_string()

      line <> bytes <> "\n"
    end)
    |> Enum.to_list()
  end

  def dump(%Computer{memory: memory}, length \\ 0xFFFF) do
    memory
    |> Stream.chunk_every(16)
    |> Stream.with_index()
    |> Stream.map(fn {[first | _] = line, index} ->
      bytes =
        line
        |> Enum.map(fn offset ->
          :io_lib.format("~2.16.0B", [offset])
        end)
        |> Enum.join(" ")

      line =
        :io_lib.format("~4.16.0B | ", [index * 16])
        |> IO.chardata_to_string()

      line <> bytes <> "\n"
    end)
    |> Stream.take(length)
  end

  defp ensure_all_are_8_bit(values) do
    values
    |> Enum.find(fn value -> value > 0xFF end)
    |> case do
      nil -> true
      val -> {false, val}
    end
  end
end

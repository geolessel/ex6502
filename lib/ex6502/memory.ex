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
      |> Enum.slice(c.address_bus, 2)
      |> Computer.resolve_address()

    c
    |> Map.put(:address_bus, address + index)
    |> absolute()
  end

  def get(memory, location) do
    Enum.at(memory, location)
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

defmodule Ex6502.Memory do
  use GenServer
  use Bitwise

  @max_size 0xFFFF

  # CLIENT API

  def start() do
    GenServer.start_link(__MODULE__, @max_size, name: __MODULE__)
  end

  def set(location, value) when location <= @max_size and value <= 0xFF do
    GenServer.call(__MODULE__, {:set, location, value})
  end

  def set(_location, _value), do: {:error, :value_too_large}

  def get(location) when location <= @max_size do
    GenServer.call(__MODULE__, {:get, location})
  end

  def absolute(location) do
    location
    |> resolve_address()
    |> get()
  end

  def absolute(location, index) do
    location
    |> resolve_address()
    |> Kernel.+(index)
    |> get()
  end

  def load(location, values) when is_list(values) do
    GenServer.call(__MODULE__, {:load, location, values})
  end

  def dump do
    GenServer.call(__MODULE__, :dump)
  end

  defp resolve_address(location) do
    low = get(location)
    high = get(location + 1)
    (high <<< 8) + low
  end

  # SERVER API

  @impl true
  def init(size) do
    memory =
      0..(size - 1)
      |> Enum.map(fn _ -> 0 end)

    {:ok, memory}
  end

  @impl true
  def handle_call(:dump, _from, memory) do
    {:reply, memory, memory}
  end

  @impl true
  def handle_call({:set, location, value}, _from, memory) do
    memory = List.replace_at(memory, location, value)
    {:reply, {:ok, value}, memory}
  end

  @impl true
  def handle_call({:get, location}, _from, memory) do
    {:reply, Enum.at(memory, location), memory}
  end

  @impl true
  def handle_call({:load, location, values}, _from, memory) do
    values
    |> ensure_all_are_8_bit()
    |> case do
      true ->
        memory =
          values
          |> Enum.with_index()
          |> Enum.reduce(memory, fn {value, i}, acc ->
            List.replace_at(acc, location + i, value)
          end)

        {:reply, :ok, memory}

      {false, val} ->
        {:reply, {:error, :value_too_large, val}, memory}
    end
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

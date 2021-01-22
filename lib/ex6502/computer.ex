defmodule Ex6502.Computer do
  alias Ex6502.{Computer, CPU, Memory}
  use Bitwise

  defstruct cpu: %Ex6502.CPU{}, cycles: 0, memory: [], address_bus: 0xFFFF, data_bus: 0xFF

  def init(opts \\ []) do
    memory =
      opts[:memory] ||
        with {:ok, memory} <- Memory.init(0xFFFF) do
          memory
        end

    %Computer{cpu: CPU.init(), memory: memory}
    |> reset()
  end

  def reset(%Computer{} = c) do
    address =
      c.memory
      |> Enum.slice(c.cpu.pc, 2)
      |> resolve_address()

    c
    # reset vector
    |> Map.put(:address_bus, address)
    |> Map.update(:cpu, :no_cpu, fn cpu -> Map.put(cpu, :pc, address) end)
  end

  def load(%Computer{memory: memory} = c, location, values) do
    Map.put(c, :memory, Memory.load(memory, location, values))
  end

  def step(%Computer{} = c) do
    c
    |> update_data_bus_from_address_bus()
    |> step_pc()
    |> CPU.execute_instruction()
  end

  def put_next_byte_on_data_bus(%Computer{cpu: cpu, memory: memory} = c) do
    c
    |> Map.put(:data_bus, Enum.at(memory, cpu.pc))
    |> step_pc()
  end

  def put_absolute_address_on_bus(%Computer{cpu: cpu, memory: memory} = c) do
    c
    |> Map.put(:address_bus, resolve_address(Enum.slice(memory, cpu.pc, 2)))
    |> step_pc(2)
  end

  def put_zero_page_on_address_bus(%Computer{} = c, index \\ 0) do
    c
    |> Map.put(:address_bus, Memory.get(c.memory, c.cpu.pc) + index)
    |> step_pc()
  end

  def resolve_address([low, high]), do: (high <<< 8) + low

  defp step_pc(%Computer{cpu: cpu} = c, amount \\ 1) do
    Map.put(c, :cpu, CPU.step_pc(cpu, amount))
  end

  defp update_data_bus_from_address_bus(%Computer{address_bus: address, memory: memory} = c) do
    c
    |> Map.put(:data_bus, Enum.at(memory, address))
  end
end

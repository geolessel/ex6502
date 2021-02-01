defmodule Ex6502.CPU.Stack do
  alias Ex6502.{Computer, Memory}

  @page 0x01

  def push(%Computer{} = c, value) do
    c
    |> Computer.load(resolve_address(c.cpu.sp), [value])
    |> Map.put(:cpu, %{c.cpu | sp: c.cpu.sp - 1})
  end

  def pop(%Computer{} = c) do
    with c <- Map.put(c, :cpu, %{c.cpu | sp: c.cpu.sp + 1}) do
      value = Memory.get(c.memory, resolve_address(c.cpu.sp))
      {value, c}
    end
  end

  def pop_to(%Computer{} = c, register) do
    with c <- Map.put(c, :cpu, %{c.cpu | sp: c.cpu.sp + 1}) do
      value = Memory.get(c.memory, resolve_address(c.cpu.sp))
      Map.put(c, :cpu, %{c.cpu | register => value})
    end
  end

  def resolve_address(low_byte) when is_integer(low_byte) and low_byte <= 0xFF do
    Computer.resolve_address([low_byte, @page])
  end
end

defmodule Ex6502.CPU.Stack do
  alias Ex6502.Computer

  @page 0x01

  def push(%Computer{} = c, value) do
    c
    |> Computer.load(resolve_address(c.cpu.sp), [value])
    |> Map.put(:cpu, %{c.cpu | sp: c.cpu.sp - 1})
  end

  def resolve_address(low_byte) when is_integer(low_byte) and low_byte <= 0xFF do
    Computer.resolve_address([low_byte, @page])
  end
end

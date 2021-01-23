defmodule Ex6502.CPU.Executor.STX do
  @moduledoc """
  Transfer the value in the X register to memory

  ## Operation

  X -> M

  ## Flags

  No flags are affected
  """

  alias Ex6502.{Computer, Memory}

  # Absolute (STX $nnnn)
  def execute(%Computer{data_bus: 0x8E} = c) do
    with c <- Computer.put_absolute_address_on_bus(c) do
      Computer.load(c, c.address_bus, [c.cpu.x])
    end
  end

  # Zero page (STX $nn)
  def execute(%Computer{data_bus: 0x86} = c) do
    with c <-
           Computer.put_zero_page_on_address_bus(c)
           |> Memory.absolute() do
      Computer.load(c, c.address_bus, [c.cpu.x])
    end
  end

  # Y-indexed zero page (STX $nn,Y)
  def execute(%Computer{data_bus: 0x96} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c) do
      Computer.load(c, c.address_bus + c.cpu.y, [c.cpu.x])
    end
  end
end

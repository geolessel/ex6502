defmodule Ex6502.CPU.Executor.STY do
  @moduledoc """
  Transfer the value in the Y register to memory

  ## Operation

  Y -> M

  ## Flags

  No flags are affected
  """

  alias Ex6502.{Computer, Memory}

  # Absolute (STY $nnnn)
  def execute(%Computer{data_bus: 0x8C} = c) do
    with c <- Computer.put_absolute_address_on_bus(c) do
      Computer.load(c, c.address_bus, [c.cpu.y])
    end
  end

  # Zero page (STY $nn)
  def execute(%Computer{data_bus: 0x84} = c) do
    with c <-
           Computer.put_zero_page_on_address_bus(c)
           |> Memory.absolute() do
      Computer.load(c, c.address_bus, [c.cpu.y])
    end
  end

  # X-indexed zero page (STY $nn,X)
  def execute(%Computer{data_bus: 0x94} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c) do
      Computer.load(c, c.address_bus + c.cpu.x, [c.cpu.y])
    end
  end
end

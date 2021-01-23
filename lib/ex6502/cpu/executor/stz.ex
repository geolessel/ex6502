defmodule Ex6502.CPU.Executor.STZ do
  @moduledoc """
  Transfer the value 0 to memory

  ## Operation

  0 -> M

  ## Flags

  No flags are affected
  """

  alias Ex6502.{Computer, Memory}

  use Bitwise

  # Absolute (STZ $nnnn)
  def execute(%Computer{data_bus: 0x9C} = c) do
    with c <- Computer.put_absolute_address_on_bus(c) do
      Computer.load(c, c.address_bus, [0x00])
    end
  end

  # X-indexed Absolute (STZ $nnnn,X)
  def execute(%Computer{data_bus: 0x9E} = c) do
    with c <- Computer.put_absolute_address_on_bus(c) do
      Computer.load(c, c.address_bus + c.cpu.x, [0x00])
    end
  end

  # Zero page (STZ $nn)
  def execute(%Computer{data_bus: 0x64} = c) do
    with c <-
           Computer.put_zero_page_on_address_bus(c)
           |> Memory.absolute() do
      Computer.load(c, c.address_bus, [c.cpu.y])
    end
  end

  # X-indexed zero page (STZ $nn,X)
  def execute(%Computer{data_bus: 0x74} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c) do
      Computer.load(c, c.address_bus + c.cpu.x, [c.cpu.y])
    end
  end
end

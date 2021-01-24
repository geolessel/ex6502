defmodule Ex6502.CPU.Executor.PHP do
  @moduledoc """
  Transfer the value of the processor status register to the stack

  ## Operation

  P↓

  ## Flags

  No flags are affected
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0x08} = c) do
    CPU.Stack.push(c, c.cpu.p)
  end
end

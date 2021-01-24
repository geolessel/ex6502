defmodule Ex6502.CPU.Executor.PHA do
  @moduledoc """
  Transfer the value of the accumulator to the stack

  ## Operation

  A↓

  ## Flags

  No flags are affected
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0x48} = c) do
    CPU.Stack.push(c, c.cpu.a)
  end
end

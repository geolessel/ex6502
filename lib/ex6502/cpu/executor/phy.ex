defmodule Ex6502.CPU.Executor.PHY do
  @moduledoc """
  Transfer the value of the Y register to the stack

  ## Operation

  Y↓

  ## Flags

  No flags are affected
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0x5A} = c) do
    CPU.Stack.push(c, c.cpu.y)
  end
end

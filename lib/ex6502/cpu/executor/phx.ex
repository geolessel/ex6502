defmodule Ex6502.CPU.Executor.PHX do
  @moduledoc """
  Transfer the value of the X register to the stack

  ## Operation

  X↓

  ## Flags

  No flags are affected
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0xDA} = c) do
    CPU.Stack.push(c, c.cpu.x)
  end
end

defmodule Ex6502.CPU.Executor.PLX do
  @moduledoc """
  Transfer the value from the stack to the X register

  ## Operation

  X↑

  ## Flags

  - Zero:     1 if X is zero; 0 otherwise
  - Negative: 1 if bit 7 of X is set; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0xFA} = c) do
    CPU.Stack.pop_to(c, :x)
  end
end

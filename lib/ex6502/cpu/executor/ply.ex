defmodule Ex6502.CPU.Executor.PLY do
  @moduledoc """
  Transfer the value from the stack to the Y register

  ## Operation

  Y↑

  ## Flags

  - Zero:     1 if Y is zero; 0 otherwise
  - Negative: 1 if bit 7 of Y is set; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0x7A} = c) do
    CPU.Stack.pop_to(c, :y)
  end
end

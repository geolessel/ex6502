defmodule Ex6502.CPU.Executor.PLA do
  @moduledoc """
  Transfer the value from the current stack pointer to the accumulator

  ## Operation

  A↑

  ## Flags

  - Zero:     1 if accumulator is zero; 0 otherwise
  - Negative: 1 if bit 7 of accumulator is set; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0x68} = c) do
    CPU.Stack.pop_to(c, :a)
  end
end

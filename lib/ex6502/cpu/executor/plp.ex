defmodule Ex6502.CPU.Executor.PLP do
  @moduledoc """
  Transfer the value from the stack to the processor status register

  ## Operation

  P↑

  ## Flags

  Changes _all_ flags (other than `B`) since that is the whole point
  of the command.
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0x28} = c) do
    CPU.Stack.pop_to(c, :p)
  end
end

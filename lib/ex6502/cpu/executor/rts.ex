defmodule Ex6502.CPU.Executor.RTS do
  @moduledoc """
  Return from subroutine

  Loads the program count low and high from the stack into the program counter
  and increments to program counter so that it points to the instruction
  following the JSR.

  ## Operation

  PC↑
  PC + 1 → PC

  ## Table

      RTS | Jump to Subroutine
      ==================================================

      PC↑                                N V - B D I Z C
      PC + 1 → PC                       - - - - - - - -

      addressing       assembler      opc  bytes  cycles
      --------------------------------------------------
      implied          RTS             60    1      6
  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler      opc  bytes  cycles
  # implied          RTS             60    1      6
  def execute(%Computer{data_bus: 0x60} = c) do
    with {low, c} <- CPU.Stack.pop(c),
         {high, c} <- CPU.Stack.pop(c) do
      CPU.set(c, :pc, Computer.resolve_address([low, high]) + 1)
    end
  end
end

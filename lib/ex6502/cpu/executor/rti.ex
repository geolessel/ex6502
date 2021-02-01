defmodule Ex6502.CPU.Executor.RTI do
  @moduledoc """
  Return from interrup

  Transfers the status and program counter for the instruction that was
  interrupted. Reinitializes all flags to the point they were at at the time
  the interrupt was taken and sets the program counter back to its
  pre-interrupt state.

  ## Operation

  P↑
  PC↑

  ## Table

      RTI | Jump to Subroutine
      ==================================================

      P↑                                 N V - B D I Z C
      PC↑                                + + - - + + + +

      addressing       assembler      opc  bytes  cycles
      --------------------------------------------------
      implied          RTI             40    1      6
  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler      opc  bytes  cycles
  # implied          RTI             40    1      6
  def execute(%Computer{data_bus: 0x40} = c) do
    with c <- CPU.Stack.pop_to(c, :p),
         {low, c} <- CPU.Stack.pop(c),
         {high, c} <- CPU.Stack.pop(c) do
      CPU.set(c, :pc, Computer.resolve_address([low, high]))
    end
  end
end

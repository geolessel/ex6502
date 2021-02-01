defmodule Ex6502.CPU.Executor.BEQ do
  @moduledoc """
  Branch on result zero.

  Could also be called "Branch on Equal".

  Take a conditional branch if the zero bit is set (1)

  ## Table

      BEQ | Branch on Result Zero (on Equal)
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      relative         BEQ $nnnn    F0     2     2 tp

      p: +1 if page is crossed
      t: +1 if branch is taken

  """

  alias Ex6502.{Computer, CPU}
  import CPU.Executor.Branching

  # addressing       assembler    opc  bytes  cycles
  # relative         BEQ $nnnn    F0     2     2 tp
  def execute(%Computer{data_bus: 0xF0} = c), do: branch(c, CPU.flag(c, :z))
end

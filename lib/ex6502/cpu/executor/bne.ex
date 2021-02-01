defmodule Ex6502.CPU.Executor.BNE do
  @moduledoc """
  Branch on result not zero

  Take a conditional branch if the Z bit is reset (clear/0)

  ## Table

      BNE | Branch on Result Not Zero (Not Equal)
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      relative         BNE $nnnn    D0     2     2 tp

      p: +1 if page is crossed
      t: +1 if branch is taken

  """

  alias Ex6502.{Computer, CPU}
  import CPU.Executor.Branching

  # addressing       assembler    opc  bytes  cycles
  # relative         BNE $nnnn    D0     2     2 tp
  def execute(%Computer{data_bus: 0xD0} = c), do: branch(c, !CPU.flag(c, :z))
end

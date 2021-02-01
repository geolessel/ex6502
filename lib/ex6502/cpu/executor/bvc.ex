defmodule Ex6502.CPU.Executor.BVC do
  @moduledoc """
  Branch on overflow clear

  Take a conditional branch if the V bit is reset (clear/0)

  ## Table

      BVC | Branch on Overflow Clear
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      relative         BVC $nnnn    50     2     2 tp

      p: +1 if page is crossed
      t: +1 if branch is taken

  """

  alias Ex6502.{Computer, CPU}
  import CPU.Executor.Branching

  # addressing       assembler    opc  bytes  cycles
  # relative         BVC $nnnn    50     2     2 tp
  def execute(%Computer{data_bus: 0x50} = c), do: branch(c, !CPU.flag(c, :v))
end

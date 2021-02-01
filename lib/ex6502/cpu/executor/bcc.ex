defmodule Ex6502.CPU.Executor.BCC do
  @moduledoc """
  Take a conditional branch if the carry bit is reset (clear/0)

  ## Table

      BCC | Branch on Carry Clear
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      relative         BCC $nnnn    90     2     2 tp

      p: +1 if page is crossed
      t: +1 if branch is taken

  """

  alias Ex6502.{Computer, CPU}
  import CPU.Executor.Branching

  # addressing       assembler    opc  bytes  cycles
  # relative         BCC $nnnn    90     2     2 tp
  def execute(%Computer{data_bus: 0x90} = c), do: branch(c, !CPU.flag(c, :c))
end

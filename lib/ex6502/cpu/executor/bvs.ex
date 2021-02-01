defmodule Ex6502.CPU.Executor.BVS do
  @moduledoc """
  Branch on overflow set

  Take a conditional branch if the V bit is set (1)

  ## Table

      BVS | Branch on Overflow Set
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      relative         BVS $nnnn    70     2     2 tp

      p: +1 if page is crossed
      t: +1 if branch is taken

  """

  alias Ex6502.{Computer, CPU}
  import CPU.Executor.Branching

  # addressing       assembler    opc  bytes  cycles
  # relative         BVS $nnnn    70     2     2 tp
  def execute(%Computer{data_bus: 0x70} = c), do: branch(c, CPU.flag(c, :v))
end

defmodule Ex6502.CPU.Executor.BCS do
  @moduledoc """
  Take a conditional branch if the carry bit is set (1)

  ## Table

      BCS | Branch on Carry Set
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      relative         BCS $nnnn    B0     2     2 tp

      p: +1 if page is crossed
      t: +1 if branch is taken

  """

  alias Ex6502.{Computer, CPU}
  import CPU.Executor.Branching

  # addressing       assembler    opc  bytes  cycles
  # relative         BCS $nnnn    B0     2     2 tp
  def execute(%Computer{data_bus: 0xB0} = c), do: branch(c, CPU.flag(c, :c))
end

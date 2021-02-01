defmodule Ex6502.CPU.Executor.BMI do
  @moduledoc """
  Branch on result minus

  Take a conditional branch if the N bit is set (1)

  ## Table

      BMI | Branch on Result Minus
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      relative         BMI $nnnn    30     2     2 tp

      p: +1 if page is crossed
      t: +1 if branch is taken

  """

  alias Ex6502.{Computer, CPU}
  import CPU.Executor.Branching

  # addressing       assembler    opc  bytes  cycles
  # relative         BMI $nnnn    30     2     2 tp
  def execute(%Computer{data_bus: 0x30} = c), do: branch(c, CPU.flag(c, :n))
end

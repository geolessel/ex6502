defmodule Ex6502.CPU.Executor.CLV do
  @moduledoc """
  Clear overflow flag

  Reset or clear the overflow flag to 0

  ## Operation

  0 → V

  ## Table

      CLV | Clear Overflow Flag
      ================================================

                                       N V - B D I Z C
                                       - 0 - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          CLV          B8     1      2

  ## Flags

  Overflow: resets to 0 always

  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler    opc  bytes  cycles
  # implied          CLV          B8     1      2
  def execute(%Computer{data_bus: 0xB8} = c), do: CPU.set_flag(c, :v, false)
end

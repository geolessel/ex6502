defmodule Ex6502.CPU.Executor.CLD do
  @moduledoc """
  Clear decimal mode flag

  Reset or clear the decimal mode flag to 0

  ## Operation

  0 → D

  ## Table

      CLD | Clear Decimal Mode
      ================================================

                                       N V - B D I Z C
                                       - - - - 0 - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          CLD          D8     1      2

  ## Flags

  Decimal: resets to 0 always

  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler    opc  bytes  cycles
  # implied          CLD          D8     1      2
  def execute(%Computer{data_bus: 0xD8} = c), do: CPU.set_flag(c, :d, false)
end

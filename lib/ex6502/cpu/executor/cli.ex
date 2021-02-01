defmodule Ex6502.CPU.Executor.CLI do
  @moduledoc """
  Clear interrupt disable flag

  Reset or clear the interrupt disable flag to 0

  ## Operation

  0 → I

  ## Table

      CLI | Clear Decimal Mode
      ================================================

                                       N V - B D I Z C
                                       - - - - - 0 - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          CLI          58     1      2

  ## Flags

  Interrupt: resets to 0 always

  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler    opc  bytes  cycles
  # implied          CLI          58     1      2
  def execute(%Computer{data_bus: 0x58} = c), do: CPU.set_flag(c, :i, false)
end

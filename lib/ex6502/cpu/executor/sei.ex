defmodule Ex6502.CPU.Executor.SEI do
  @moduledoc """
  Set interrupt disable

  Set the interrupt disable flag to 1

  ## Operation

  1 → I

  ## Table

      SEI | Set Interrupt Disable
      ================================================

                                       N V - B D I Z C
                                       - - - - - 1 - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          SEI          78     1      2

  ## Flags

  Interrupt: sets to 1 always

  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler    opc  bytes  cycles
  # implied          SEI          78     1      2
  def execute(%Computer{data_bus: 0x78} = c), do: CPU.set_flag(c, :i, true)
end

defmodule Ex6502.CPU.Executor.SED do
  @moduledoc """
  Set decimal mode

  Set the demical mode to 1

  ## Operation

  1 → D

  ## Table

      SED | Set Decimal Mode
      ================================================

                                       N V - B D I Z C
                                       - - - - 1 - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          SED          F8     1      2

  ## Flags

  Decimal: sets to 1 always

  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler    opc  bytes  cycles
  # implied          SED          F8     1      2
  def execute(%Computer{data_bus: 0xF8} = c), do: CPU.set_flag(c, :d, true)
end

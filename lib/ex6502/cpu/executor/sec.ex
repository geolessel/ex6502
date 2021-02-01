defmodule Ex6502.CPU.Executor.SEC do
  @moduledoc """
  Set carry flag

  Set the carry flag to 1

  ## Operation

  1 → V

  ## Table

      SEC | Set Carry Flag
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - 1

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          SEC          38     1      2

  ## Flags

  Carry: sets to 1 always

  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler    opc  bytes  cycles
  # implied          SEC          38     2      2
  def execute(%Computer{data_bus: 0x38} = c), do: CPU.set_flag(c, :c, true)
end

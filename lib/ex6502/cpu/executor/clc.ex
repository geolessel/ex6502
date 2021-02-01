defmodule Ex6502.CPU.Executor.CLC do
  @moduledoc """
  Clear carry flag

  Reset or clear the carry flag to 0. This operation should normally precede
  an `ADC` loop. It is also useful when used with a `ROL` instruction to clear
  a bit in memory

  ## Operation

  0 → C

  ## Table

      CLC | Clear Carry Flag
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - 0

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          CLC          18     1      2

  ## Flags

  Carry: resets to 0 always

  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler    opc  bytes  cycles
  # implied          CLC          18     1      2
  def execute(%Computer{data_bus: 0x18} = c), do: CPU.set_flag(c, :c, false)
end

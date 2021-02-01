defmodule Ex6502.CPU.Executor.BEQ do
  @moduledoc """
  Branch on result zero.

  Could also be called "Branch on Equal".

  Take a conditional branch if the zero bit is set (1)

  ## Table

      BEQ | Branch on Result Zero (on Equal)
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      relative         BEQ $nnnn    F0     2     2 tp

      p: +1 if page is crossed
      t: +1 if branch is taken

  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler    opc  bytes  cycles
  # relative         BEQ $nnnn    F0     2     2 tp
  def execute(%Computer{data_bus: 0xF0} = c) do
    with %Computer{address_bus: address} = c <- Computer.put_absolute_address_on_bus(c) do
      if CPU.flag(c, :z) do
        <<_unused::integer-8, offset::signed-integer-8>> = <<address::integer-16>>
        CPU.set(c, :pc, c.cpu.pc + offset)
      else
        c
      end
    end
  end
end

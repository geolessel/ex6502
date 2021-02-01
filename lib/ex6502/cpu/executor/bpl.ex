defmodule Ex6502.CPU.Executor.BPL do
  @moduledoc """
  Branch on result plus

  Take a conditional branch if the N bit is reset (clear/0)

  ## Table

      BPL | Branch on Result Plus
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      relative         BPL $nnnn    10     2     2 tp

      p: +1 if page is crossed
      t: +1 if branch is taken

  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler    opc  bytes  cycles
  # relative         BPL $nnnn    10     2     2 tp
  def execute(%Computer{data_bus: 0x10} = c) do
    with %Computer{address_bus: address} = c <- Computer.put_absolute_address_on_bus(c) do
      if CPU.flag(c, :n) do
        c
      else
        <<_unused::integer-8, offset::signed-integer-8>> = <<address::integer-16>>
        CPU.set(c, :pc, c.cpu.pc + offset)
      end
    end
  end
end

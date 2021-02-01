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

  # addressing       assembler    opc  bytes  cycles
  # relative         BMI $nnnn    30     2     2 tp
  def execute(%Computer{data_bus: 0x30} = c) do
    with %Computer{address_bus: address} = c <- Computer.put_absolute_address_on_bus(c) do
      if CPU.flag(c, :n) do
        <<_unused::integer-8, offset::signed-integer-8>> = <<address::integer-16>>
        CPU.set(c, :pc, c.cpu.pc + offset)
      else
        c
      end
    end
  end
end

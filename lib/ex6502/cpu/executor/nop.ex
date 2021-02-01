defmodule Ex6502.CPU.Executor.NOP do
  @moduledoc """
  No operation

  ## Table

      NOP | No Operation
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          NOP          EA     1      2

  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler    opc  bytes  cycles
  # implied          NOP          EA     1      2
  def execute(%Computer{data_bus: 0xEA} = c), do: c
end

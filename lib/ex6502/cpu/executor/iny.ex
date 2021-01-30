defmodule Ex6502.CPU.Executor.INY do
  @moduledoc """
  Add 1 to the Y register, not affecting carry

  ## Operation

  Y - 1 -> Y

  ## Table

      INY | Increment Index Register Y by 1
      ================================================

      Y - 1 -> Y                       N V - B D I Z C
                                       + - - - - - + -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          INY           C8    1      2

  ## Flags

  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  - Zero:     1 if result is zero; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  use Bitwise

  # addressing       assembler    opc  bytes  cycles
  # implied          INY           C8    1      2
  def execute(%Computer{data_bus: 0xC8} = c) do
    result = c.cpu.y + 1 &&& 0xFF

    c
    |> CPU.set(:y, result)
    |> CPU.set_flags([:n, :z], result)
  end
end

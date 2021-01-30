defmodule Ex6502.CPU.Executor.DEY do
  @moduledoc """
  Subtract 1, in two's complement, from the Y register

  ## Operation

  Y - 1 -> Y

  ## Table

      DEY | Decrement Index Register Y by 1
      ================================================

      Y - 1 -> Y                       N V - B D I Z C
                                       + - - - - - + -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          DEY           88    1      2

  ## Flags

  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  - Zero:     1 if result is zero; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  use Bitwise

  # addressing       assembler    opc  bytes  cycles
  # implied          DEY           88    1      2
  def execute(%Computer{data_bus: 0x88} = c) do
    # subtraction is really addition with the complement
    <<result::unsigned>> = <<c.cpu.y + (~~~0x01 + 1)>>

    c
    |> CPU.set(:y, result)
    |> CPU.set_flags([:n, :z], result)
  end
end

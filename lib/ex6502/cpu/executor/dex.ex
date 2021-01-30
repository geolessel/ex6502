defmodule Ex6502.CPU.Executor.DEX do
  @moduledoc """
  Subtract 1, in two's complement, from the X register

  ## Operation

  X - 1 -> X

  ## Table

      DEX | Decrement Index Register X by 1
      ================================================

      X - 1 -> X                       N V - B D I Z C
                                       + - - - - - + -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          DEX           CA    1     2

  ## Flags

  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  - Zero:     1 if result is zero; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  use Bitwise

  # addressing       assembler    opc  bytes  cycles
  # implied          DEX           CA    1     2
  def execute(%Computer{data_bus: 0xCA} = c) do
    # subtraction is really addition with the complement
    <<result::unsigned>> = <<c.cpu.x + (~~~0x01 + 1)>>

    c
    |> CPU.set(:x, result)
    |> CPU.set_flags([:n, :z], result)
  end
end

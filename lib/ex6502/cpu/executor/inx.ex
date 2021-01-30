defmodule Ex6502.CPU.Executor.INX do
  @moduledoc """
  Add 1 to the X register, not affecting carry

  ## Operation

  X - 1 -> X

  ## Table

      INX | Increment Index Register X by 1
      ================================================

      X - 1 -> X                       N V - B D I Z C
                                       + - - - - - + -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          INX           E8    1      2

  ## Flags

  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  - Zero:     1 if result is zero; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  use Bitwise

  # addressing       assembler    opc  bytes  cycles
  # implied          INX           E8    1      2
  def execute(%Computer{data_bus: 0xE8} = c) do
    result = c.cpu.x + 1 &&& 0xFF

    c
    |> CPU.set(:x, result)
    |> CPU.set_flags([:n, :z], result)
  end
end

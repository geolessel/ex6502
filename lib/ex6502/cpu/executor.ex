defmodule Ex6502.CPU.Executor do
  @moduledoc """
  Handles executing opcodes.
  """

  alias Ex6502.{CPU, Memory}

  use Bitwise

  @doc """
  LDA Immediate (LDA #$nn)

  ## Operation

  M -> A

  Transfer data from memory to the accumulator.

  ## Flags
    - Negative: 1 if bit 7 of accumulator is set, 0 otherwise
    - Zero:     1 if accumulator is zero, 0 otherwise
  """
  def execute(0xA9) do
    pc = CPU.get(:pc)
    value = Memory.get(pc + 1)
    CPU.set(:a, value)
    CPU.advance_pc(2)

    # is bit 7 a 1?
    CPU.set_flag(:n, (value &&& 1 <<< 7) >>> 7)
    CPU.set_flag(:z, value == 0)
  end
end

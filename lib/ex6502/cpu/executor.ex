defmodule Ex6502.CPU.Executor do
  @moduledoc """
  Handles executing opcodes.
  """

  alias Ex6502.CPU.Executor

  @lda [0xA9, 0xAD, 0xBD, 0xB9, 0xA5, 0xB5, 0xB2, 0xA1, 0xB1]

  def execute(opcode) when opcode in @lda,
    do: Executor.LDA.execute(opcode)

  @ldx [0xA2, 0xAE, 0xBE, 0xA6, 0xB6]

  def execute(opcode) when opcode in @ldx,
    do: Executor.LDX.execute(opcode)
end

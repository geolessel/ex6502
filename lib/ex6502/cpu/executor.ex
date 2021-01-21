defmodule Ex6502.CPU.Executor do
  @moduledoc """
  Handles executing opcodes.
  """

  @lda [0xA9, 0xAD, 0xBD, 0xB9, 0xA5, 0xB5, 0xB2, 0xA1, 0xB1]

  def execute(opcode) when opcode in @lda do
    Ex6502.CPU.Executor.LDA.execute(opcode)
  end
end

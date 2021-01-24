defmodule Ex6502.CPU.Executor do
  @moduledoc """
  Handles executing opcodes.
  """

  alias Ex6502.Computer
  alias Ex6502.CPU.Executor

  @lda [0xA9, 0xAD, 0xBD, 0xB9, 0xA5, 0xB5, 0xB2, 0xA1, 0xB1]
  @ldx [0xA2, 0xAE, 0xBE, 0xA6, 0xB6]
  @ldy [0xA0, 0xAC, 0xBC, 0xA4, 0xB4]
  @sta [0x8D, 0x9D, 0x99, 0x85, 0x95, 0x92, 0x81, 0x91]
  @stx [0x8E, 0x86, 0x96]
  @sty [0x8C, 0x84, 0x94]
  @stz [0x9C, 0x9E, 0x64, 0x74]
  @tax [0xAA]
  @tay [0xA8]
  @tsx [0xBA]
  @txa [0x8A]
  @tya [0x98]
  @txs [0x9A]
  @pha [0x48]
  @brk [0x00]

  def execute(%Computer{data_bus: opcode} = c) when opcode in @lda,
    do: Executor.LDA.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @ldx,
    do: Executor.LDX.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @ldy,
    do: Executor.LDY.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @sta,
    do: Executor.STA.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @stx,
    do: Executor.STX.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @sty,
    do: Executor.STY.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @stz,
    do: Executor.STZ.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @tax,
    do: Executor.TAX.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @tay,
    do: Executor.TAY.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @tsx,
    do: Executor.TSX.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @txa,
    do: Executor.TXA.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @tya,
    do: Executor.TYA.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @txs,
    do: Executor.TXS.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @pha,
    do: Executor.PHA.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @brk,
    do: Executor.BRK.execute(c)
end

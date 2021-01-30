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
  @php [0x08]
  @phx [0xDA]
  @phy [0x5A]
  @pla [0x68]
  @plp [0x28]
  @plx [0xFA]
  @ply [0x7A]
  @asl [0x0A, 0x0E, 0x1E, 0x06, 0x16]
  @lsr [0x4A, 0x4E, 0x5E, 0x46, 0x56]
  @rol [0x2A, 0x2E, 0x3E, 0x26, 0x36]
  @ror [0x6A, 0x6E, 0x7E, 0x66, 0x76]
  @andcodes [0x29, 0x2D, 0x3D, 0x39, 0x25, 0x35, 0x32, 0x21, 0x31]
  @bit [0x89, 0x2C, 0x3C, 0x24, 0x34]
  @eor [0x49, 0x4D, 0x5D, 0x59, 0x45, 0x55, 0x52, 0x41, 0x51]
  @ora [0x09, 0x0D, 0x1D, 0x19, 0x05, 0x15, 0x12, 0x01, 0x11]
  @trb [0x1C, 0x14]
  @tsb [0x0C, 0x04]
  @adc [0x69, 0x6D, 0x7D, 0x79, 0x65, 0x75, 0x72, 0x61, 0x71]
  @cmp [0xC9, 0xCD, 0xDD, 0xD9, 0xC5, 0xD5, 0xD2, 0xC1, 0xD1]
  @cpx [0xE0, 0xEC, 0xE4]
  @cpy [0xC0, 0xCC, 0xC4]
  @sbc [0xE9, 0xED, 0xFD, 0xF9, 0xE5, 0xF5, 0xF2, 0xE1, 0xF1]
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

  def execute(%Computer{data_bus: opcode} = c) when opcode in @php,
    do: Executor.PHP.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @phx,
    do: Executor.PHX.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @phy,
    do: Executor.PHY.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @pla,
    do: Executor.PLA.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @plp,
    do: Executor.PLP.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @plx,
    do: Executor.PLX.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @ply,
    do: Executor.PLY.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @asl,
    do: Executor.ASL.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @lsr,
    do: Executor.LSR.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @rol,
    do: Executor.ROL.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @ror,
    do: Executor.ROR.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @andcodes,
    do: Executor.AND.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @bit,
    do: Executor.BIT.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @eor,
    do: Executor.EOR.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @ora,
    do: Executor.ORA.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @trb,
    do: Executor.TRB.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @tsb,
    do: Executor.TSB.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @adc,
    do: Executor.ADC.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @cmp,
    do: Executor.CMP.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @cpx,
    do: Executor.CPX.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @cpy,
    do: Executor.CPY.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @sbc,
    do: Executor.SBC.execute(c)

  def execute(%Computer{data_bus: opcode} = c) when opcode in @brk,
    do: Executor.BRK.execute(c)
end

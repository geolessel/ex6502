defmodule Ex6502.Disassembler do
  alias Ex6502.{Computer, Memory}

  use Bitwise

  def disassemble(%Computer{cpu: %{pc: pc}, memory: memory}) do
    [opcode, low_byte, high_byte] = Memory.get(memory, pc, 3)

    disassemble({opcode, low_byte, high_byte})
  end

  ### LDA #####################################################################
  def disassemble({0xA9, value, _}), do: print(:imm, "LDA", value)
  def disassemble({0xAD, low, high}), do: print(:abs, "LDA", little_endian(low, high))
  def disassemble({0xBD, low, high}), do: print(:x_abs, "LDA", little_endian(low, high))
  def disassemble({0xB9, low, high}), do: print(:y_abs, "LDA", little_endian(low, high))
  def disassemble({0xA5, value, _}), do: print(:zp, "LDA", value)
  def disassemble({0xB5, value, _}), do: print(:x_zp, "LDA", value)
  def disassemble({0xB2, value, _}), do: print(:zp_ind, "LDA", value)
  def disassemble({0xA1, value, _}), do: print(:x_zp_ind, "LDA", value)
  def disassemble({0xB1, value, _}), do: print(:zp_ind_y, "LDA", value)
  # - LDA end -----------------------------------------------------------------

  ### LDX #####################################################################
  def disassemble({0xA2, value, _}), do: print(:imm, "LDX", value)
  def disassemble({0xAE, low, high}), do: print(:abs, "LDX", little_endian(low, high))
  def disassemble({0xBE, low, high}), do: print(:y_abs, "LDX", little_endian(low, high))
  def disassemble({0xA6, value, _}), do: print(:zp, "LDX", value)
  def disassemble({0xB6, value, _}), do: print(:y_zp, "LDX", value)
  # - LDX end -----------------------------------------------------------------

  ### LDY #####################################################################
  def disassemble({0xA0, value, _}), do: print(:imm, "LDY", value)
  def disassemble({0xAC, low, high}), do: print(:abs, "LDY", little_endian(low, high))
  def disassemble({0xBC, low, high}), do: print(:x_abs, "LDY", little_endian(low, high))
  def disassemble({0xA4, value, _}), do: print(:zp, "LDY", value)
  def disassemble({0xB4, value, _}), do: print(:x_zp, "LDY", value)
  # - LDY end -----------------------------------------------------------------

  ### STA #####################################################################
  def disassemble({0x8D, low, high}), do: print(:abs, "STA", little_endian(low, high))
  def disassemble({0x9D, low, high}), do: print(:x_abs, "STA", little_endian(low, high))
  def disassemble({0x99, low, high}), do: print(:y_abs, "STA", little_endian(low, high))
  def disassemble({0x85, value, _}), do: print(:zp, "STA", value)
  def disassemble({0x95, value, _}), do: print(:x_zp, "STA", value)
  def disassemble({0x92, value, _}), do: print(:zp_ind, "STA", value)
  def disassemble({0x81, value, _}), do: print(:x_zp_ind, "STA", value)
  def disassemble({0x91, value, _}), do: print(:zp_ind_y, "STA", value)
  # - STA end -----------------------------------------------------------------

  ### STX #####################################################################
  def disassemble({0x8E, low, high}), do: print(:abs, "STX", little_endian(low, high))
  def disassemble({0x86, value, _}), do: print(:zp, "STX", value)
  def disassemble({0x96, value, _}), do: print(:y_zp, "STX", value)
  # - STX end -----------------------------------------------------------------

  ### STY #####################################################################
  def disassemble({0x8C, low, high}), do: print(:abs, "STY", little_endian(low, high))
  def disassemble({0x84, value, _}), do: print(:zp, "STY", value)
  def disassemble({0x94, value, _}), do: print(:x_zp, "STY", value)
  # - STY end -----------------------------------------------------------------

  ### STZ #####################################################################
  def disassemble({0x9C, low, high}), do: print(:abs, "STZ", little_endian(low, high))
  def disassemble({0x9E, low, high}), do: print(:x_abs, "STZ", little_endian(low, high))
  def disassemble({0x64, value, _}), do: print(:zp, "STZ", value)
  def disassemble({0x74, value, _}), do: print(:x_zp, "STZ", value)
  # - STZ end -----------------------------------------------------------------

  ### TAX #####################################################################
  def disassemble({0xAA, _, _}), do: print(:imp, "TAX", 0)
  # - TAX end -----------------------------------------------------------------

  ### TAY #####################################################################
  def disassemble({0xA8, _, _}), do: print(:imp, "TAY", 0)
  # - TAY end -----------------------------------------------------------------

  ### TSX #####################################################################
  def disassemble({0xBA, _, _}), do: print(:imp, "TSX", 0)
  # - TSX end -----------------------------------------------------------------

  ### TXA #####################################################################
  def disassemble({0x8A, _, _}), do: print(:imp, "TXA", 0)
  # - TXA end -----------------------------------------------------------------

  ### TXS #####################################################################
  def disassemble({0x9A, _, _}), do: print(:imp, "TXS", 0)
  # - TXS end -----------------------------------------------------------------

  ### TYA #####################################################################
  def disassemble({0x98, _, _}), do: print(:imp, "TYA", 0)
  # - TYA end -----------------------------------------------------------------

  ### PHA #####################################################################
  def disassemble({0x48, _, _}), do: print(:imp, "PHA", 0)
  # - PHA end -----------------------------------------------------------------

  ### PHP #####################################################################
  def disassemble({0x08, _, _}), do: print(:imp, "PHP", 0)
  # - PHP end -----------------------------------------------------------------

  ### PHX #####################################################################
  def disassemble({0xDA, _, _}), do: print(:imp, "PHX", 0)
  # - PHX end -----------------------------------------------------------------

  ### PHY #####################################################################
  def disassemble({0x5A, _, _}), do: print(:imp, "PHY", 0)
  # - PHY end -----------------------------------------------------------------

  ### PLA #####################################################################
  def disassemble({0x68, _, _}), do: print(:imp, "PLA", 0)
  # - PLA end -----------------------------------------------------------------

  ### PLP #####################################################################
  def disassemble({0x28, _, _}), do: print(:imp, "PLP", 0)
  # - PLP end -----------------------------------------------------------------

  ### PLX #####################################################################
  def disassemble({0xFA, _, _}), do: print(:imp, "PLX", 0)
  # - PLX end -----------------------------------------------------------------

  ### PLY #####################################################################
  def disassemble({0x7A, _, _}), do: print(:imp, "PLY", 0)
  # - PLY end -----------------------------------------------------------------

  ### ASL #####################################################################
  def disassemble({0x0A, _, _}), do: print(:imp, "ASL", 0)
  def disassemble({0x0E, low, high}), do: print(:abs, "ASL", little_endian(low, high))
  def disassemble({0x1E, low, high}), do: print(:x_abs, "ASL", little_endian(low, high))
  def disassemble({0x06, value, _}), do: print(:zp, "ASL", value)
  def disassemble({0x16, value, _}), do: print(:x_zp, "ASL", value)
  # - ASL end -----------------------------------------------------------------

  ### LSR #####################################################################
  def disassemble({0x4A, _, _}), do: print(:imp, "LSR", 0)
  def disassemble({0x4E, low, high}), do: print(:abs, "LSR", little_endian(low, high))
  def disassemble({0x5E, low, high}), do: print(:x_abs, "LSR", little_endian(low, high))
  def disassemble({0x46, value, _}), do: print(:zp, "LSR", value)
  def disassemble({0x56, value, _}), do: print(:x_zp, "LSR", value)
  # - LSR end -----------------------------------------------------------------

  ### ROL #####################################################################
  def disassemble({0x2A, _, _}), do: print(:imp, "ROL", 0)
  def disassemble({0x2E, low, high}), do: print(:abs, "ROL", little_endian(low, high))
  def disassemble({0x3E, low, high}), do: print(:x_abs, "ROL", little_endian(low, high))
  def disassemble({0x26, value, _}), do: print(:zp, "ROL", value)
  def disassemble({0x36, value, _}), do: print(:x_zp, "ROL", value)
  # - ROL end -----------------------------------------------------------------

  ### ROR #####################################################################
  def disassemble({0x6A, _, _}), do: print(:imp, "ROR", 0)
  def disassemble({0x6E, low, high}), do: print(:abs, "ROR", little_endian(low, high))
  def disassemble({0x7E, low, high}), do: print(:x_abs, "ROR", little_endian(low, high))
  def disassemble({0x66, value, _}), do: print(:zp, "ROR", value)
  def disassemble({0x76, value, _}), do: print(:x_zp, "ROR", value)
  # - ROR end -----------------------------------------------------------------

  ### AND #####################################################################
  def disassemble({0x29, value, _}), do: print(:imm, "AND", value)
  def disassemble({0x2D, low, high}), do: print(:abs, "AND", little_endian(low, high))
  def disassemble({0x3D, low, high}), do: print(:x_abs, "AND", little_endian(low, high))
  def disassemble({0x39, low, high}), do: print(:y_abs, "AND", little_endian(low, high))
  def disassemble({0x25, value, _}), do: print(:zp, "AND", value)
  def disassemble({0x35, value, _}), do: print(:x_zp, "AND", value)
  def disassemble({0x32, value, _}), do: print(:zp_ind, "AND", value)
  def disassemble({0x21, value, _}), do: print(:x_zp_ind, "AND", value)
  def disassemble({0x31, value, _}), do: print(:zp_ind_y, "AND", value)
  # - AND end -----------------------------------------------------------------

  ### BIT #####################################################################
  def disassemble({0x89, value, _}), do: print(:imm, "BIT", value)
  def disassemble({0x2C, low, high}), do: print(:abs, "BIT", little_endian(low, high))
  def disassemble({0x3C, low, high}), do: print(:x_abs, "BIT", little_endian(low, high))
  def disassemble({0x24, value, _}), do: print(:zp, "BIT", value)
  def disassemble({0x34, value, _}), do: print(:x_zp, "BIT", value)
  # - BIT end -----------------------------------------------------------------

  ### EOR #####################################################################
  def disassemble({0x49, value, _}), do: print(:imm, "EOR", value)
  def disassemble({0x4D, low, high}), do: print(:abs, "EOR", little_endian(low, high))
  def disassemble({0x5D, low, high}), do: print(:x_abs, "EOR", little_endian(low, high))
  def disassemble({0x59, low, high}), do: print(:y_abs, "EOR", little_endian(low, high))
  def disassemble({0x45, value, _}), do: print(:zp, "EOR", value)
  def disassemble({0x55, value, _}), do: print(:x_zp, "EOR", value)
  def disassemble({0x52, value, _}), do: print(:zp_ind, "EOR", value)
  def disassemble({0x41, value, _}), do: print(:x_zp_ind, "EOR", value)
  def disassemble({0x51, value, _}), do: print(:zp_ind_y, "EOR", value)
  # - EOR end -----------------------------------------------------------------

  ### ORA #####################################################################
  def disassemble({0x09, value, _}), do: print(:imm, "ORA", value)
  def disassemble({0x0D, low, high}), do: print(:abs, "ORA", little_endian(low, high))
  def disassemble({0x1D, low, high}), do: print(:x_abs, "ORA", little_endian(low, high))
  def disassemble({0x19, low, high}), do: print(:y_abs, "ORA", little_endian(low, high))
  def disassemble({0x05, value, _}), do: print(:zp, "ORA", value)
  def disassemble({0x15, value, _}), do: print(:x_zp, "ORA", value)
  def disassemble({0x12, value, _}), do: print(:zp_ind, "ORA", value)
  def disassemble({0x01, value, _}), do: print(:x_zp_ind, "ORA", value)
  def disassemble({0x11, value, _}), do: print(:zp_ind_y, "ORA", value)
  # - ORA end -----------------------------------------------------------------

  ### TRB #####################################################################
  def disassemble({0x1C, low, high}), do: print(:abs, "TRB", little_endian(low, high))
  def disassemble({0x14, value, _}), do: print(:zp, "TRB", value)
  # - TRB end -----------------------------------------------------------------

  ### TSB #####################################################################
  def disassemble({0x0C, low, high}), do: print(:abs, "TSB", little_endian(low, high))
  def disassemble({0x04, value, _}), do: print(:zp, "TSB", value)
  # - TSB end -----------------------------------------------------------------

  ### ADC #####################################################################
  def disassemble({0x69, value, _}), do: print(:imm, "ADC", value)
  def disassemble({0x6D, low, high}), do: print(:abs, "ADC", little_endian(low, high))
  def disassemble({0x7D, low, high}), do: print(:x_abs, "ADC", little_endian(low, high))
  def disassemble({0x79, low, high}), do: print(:y_abs, "ADC", little_endian(low, high))
  def disassemble({0x65, value, _}), do: print(:zp, "ADC", value)
  def disassemble({0x75, value, _}), do: print(:x_zp, "ADC", value)
  def disassemble({0x72, value, _}), do: print(:zp_ind, "ADC", value)
  def disassemble({0x61, value, _}), do: print(:x_zp_ind, "ADC", value)
  def disassemble({0x71, value, _}), do: print(:zp_ind_y, "ADC", value)
  # - ADC end -----------------------------------------------------------------

  ### CMP #####################################################################
  def disassemble({0xC9, value, _}), do: print(:imm, "CMP", value)
  def disassemble({0xCD, low, high}), do: print(:abs, "CMP", little_endian(low, high))
  def disassemble({0xDD, low, high}), do: print(:x_abs, "CMP", little_endian(low, high))
  def disassemble({0xD9, low, high}), do: print(:y_abs, "CMP", little_endian(low, high))
  def disassemble({0xC5, value, _}), do: print(:zp, "CMP", value)
  def disassemble({0xD5, value, _}), do: print(:x_zp, "CMP", value)
  def disassemble({0xD2, value, _}), do: print(:zp_ind, "CMP", value)
  def disassemble({0xC1, value, _}), do: print(:x_zp_ind, "CMP", value)
  def disassemble({0xD1, value, _}), do: print(:zp_ind_y, "CMP", value)
  # - CMP end -----------------------------------------------------------------

  ### CPX #####################################################################
  def disassemble({0xE0, value, _}), do: print(:imm, "CPX", value)
  def disassemble({0xEC, low, high}), do: print(:abs, "CPX", little_endian(low, high))
  def disassemble({0xE4, value, _}), do: print(:zp, "CPX", value)
  # - CPX end -----------------------------------------------------------------

  ### CPY #####################################################################
  def disassemble({0xC0, value, _}), do: print(:imm, "CPY", value)
  def disassemble({0xCC, low, high}), do: print(:abs, "CPY", little_endian(low, high))
  def disassemble({0xC4, value, _}), do: print(:zp, "CPY", value)
  # - CPY end -----------------------------------------------------------------

  ### SBC #####################################################################
  def disassemble({0xE9, value, _}), do: print(:imm, "SBC", value)
  def disassemble({0xED, low, high}), do: print(:abs, "SBC", little_endian(low, high))
  def disassemble({0xFD, low, high}), do: print(:x_abs, "SBC", little_endian(low, high))
  def disassemble({0xF9, low, high}), do: print(:y_abs, "SBC", little_endian(low, high))
  def disassemble({0xE5, value, _}), do: print(:zp, "SBC", value)
  def disassemble({0xF5, value, _}), do: print(:x_zp, "SBC", value)
  def disassemble({0xF2, value, _}), do: print(:zp_ind, "SBC", value)
  def disassemble({0xE1, value, _}), do: print(:x_zp_ind, "SBC", value)
  def disassemble({0xF1, value, _}), do: print(:zp_ind_y, "SBC", value)
  # - SBC end -----------------------------------------------------------------

  ### DEC #####################################################################
  def disassemble({0x3A, _, _}), do: print(:imp, "DEC", 0)
  def disassemble({0xCE, low, high}), do: print(:abs, "DEC", little_endian(low, high))
  def disassemble({0xDE, low, high}), do: print(:x_abs, "DEC", little_endian(low, high))
  def disassemble({0xC6, value, _}), do: print(:zp, "DEC", value)
  def disassemble({0xD6, value, _}), do: print(:x_zp, "DEC", value)
  # - DEC end -----------------------------------------------------------------

  ### DEX #####################################################################
  def disassemble({0xCA, _, _}), do: print(:imp, "DEX", 0)
  # - DEX end -----------------------------------------------------------------

  ### DEY #####################################################################
  def disassemble({0x88, _, _}), do: print(:imp, "DEY", 0)
  # - DEY end -----------------------------------------------------------------

  ### INC #####################################################################
  def disassemble({0x1A, _, _}), do: print(:imp, "INC", 0)
  def disassemble({0xEE, low, high}), do: print(:abs, "INC", little_endian(low, high))
  def disassemble({0xFE, low, high}), do: print(:x_abs, "INC", little_endian(low, high))
  def disassemble({0xE6, value, _}), do: print(:zp, "INC", value)
  def disassemble({0xF6, value, _}), do: print(:x_zp, "INC", value)
  # - INC end -----------------------------------------------------------------

  ### INX #####################################################################
  def disassemble({0xE8, _, _}), do: print(:imp, "INX", 0)
  # - INX end -----------------------------------------------------------------

  ### INY #####################################################################
  def disassemble({0xC8, _, _}), do: print(:imp, "INY", 0)
  # - INY end -----------------------------------------------------------------

  ### BRA #####################################################################
  def disassemble({0x80, value, _}), do: print(:rel, "BRA", value)
  # - BRA end -----------------------------------------------------------------

  ### BRK #####################################################################
  def disassemble({0x00, _, _}), do: print(:imp, "BRK", 0)
  # - BRK end -----------------------------------------------------------------

  ### JMP #####################################################################
  def disassemble({0x4C, low, high}), do: print(:abs, "JMP", little_endian(low, high))
  def disassemble({0x6C, low, high}), do: print(:abs_ind, "JMP", little_endian(low, high))
  def disassemble({0x7C, low, high}), do: print(:x_abs_ind, "JMP", little_endian(low, high))
  # - JMP end -----------------------------------------------------------------

  ### JSR #####################################################################
  def disassemble({0x20, low, high}), do: print(:abs, "JSR", little_endian(low, high))
  # - JSR end -----------------------------------------------------------------

  ### RTI #####################################################################
  def disassemble({0x40, _, _}), do: print(:imp, "RTI", 0)
  # - RTI end -----------------------------------------------------------------

  ### RTS #####################################################################
  def disassemble({0x60, _, _}), do: print(:imp, "RTS", 0)
  # - RTS end -----------------------------------------------------------------

  ### BCC #####################################################################
  def disassemble({0x90, value, _}), do: print(:rel, "BCC", value)
  # - BCC end -----------------------------------------------------------------

  ### BCS #####################################################################
  def disassemble({0xB0, value, _}), do: print(:rel, "BCS", value)
  # - BCS end -----------------------------------------------------------------

  ### BEQ #####################################################################
  def disassemble({0xF0, value, _}), do: print(:rel, "BEQ", value)
  # - BEQ end -----------------------------------------------------------------

  ### BMI #####################################################################
  def disassemble({0x30, value, _}), do: print(:rel, "BMI", value)
  # - BMI end -----------------------------------------------------------------

  ### BNE #####################################################################
  def disassemble({0xD0, value, _}), do: print(:rel, "BNE", value)
  # - BNE end -----------------------------------------------------------------

  ### BPL #####################################################################
  def disassemble({0x10, value, _}), do: print(:rel, "BPL", value)
  # - BPL end -----------------------------------------------------------------

  ### BVC #####################################################################
  def disassemble({0x50, value, _}), do: print(:rel, "BVC", value)
  # - BVC end -----------------------------------------------------------------

  ### BVS #####################################################################
  def disassemble({0x70, value, _}), do: print(:rel, "BVS", value)
  # - BVS end -----------------------------------------------------------------

  ### CLC #####################################################################
  def disassemble({0x18, _, _}), do: print(:imp, "CLC", 0)
  # - CLC end -----------------------------------------------------------------

  ### CLD #####################################################################
  def disassemble({0xD8, _, _}), do: print(:imp, "CLD", 0)
  # - CLD end -----------------------------------------------------------------

  ### CLI #####################################################################
  def disassemble({0x58, _, _}), do: print(:imp, "CLI", 0)
  # - CLI end -----------------------------------------------------------------

  ### CLV #####################################################################
  def disassemble({0xB8, _, _}), do: print(:imp, "CLV", 0)
  # - CLV end -----------------------------------------------------------------

  ### SEC #####################################################################
  def disassemble({0x38, _, _}), do: print(:imp, "SEC", 0)
  # - SEC end -----------------------------------------------------------------

  ### SED #####################################################################
  def disassemble({0xF8, _, _}), do: print(:imp, "SED", 0)
  # - SED end -----------------------------------------------------------------

  ### SEI #####################################################################
  def disassemble({0x78, _, _}), do: print(:imp, "SEI", 0)
  # - SEI end -----------------------------------------------------------------

  ### NOP #####################################################################
  def disassemble({0xEA, _, _}), do: print(:imp, "NOP", 0)
  # - NOP end -----------------------------------------------------------------

  def disassemble(c) do
    IO.inspect(c, base: :hex, label: "unknown disassembler")
    "???"
  end

  def print(:imp, mnenomic, _value), do: "#{mnenomic}"
  def print(:imm, mnenomic, value), do: "#{mnenomic} #$#{hex_value(value, bytes: 1)}"
  def print(:abs, mnenomic, value), do: "#{mnenomic} $#{hex_value(value, bytes: 2)}"
  def print(:abs_ind, mnenomic, value), do: "#{mnenomic} ($#{hex_value(value, bytes: 2)})"
  def print(:x_abs_ind, mnenomic, value), do: "#{mnenomic} ($#{hex_value(value, bytes: 2)},X)"
  def print(:x_abs, mnenomic, value), do: "#{mnenomic} $#{hex_value(value, bytes: 2)},X"
  def print(:y_abs, mnenomic, value), do: "#{mnenomic} $#{hex_value(value, bytes: 2)},Y"
  def print(:zp, mnenomic, value), do: "#{mnenomic} $#{hex_value(value, bytes: 1)}"
  def print(:x_zp, mnenomic, value), do: "#{mnenomic} $#{hex_value(value, bytes: 1)},X"
  def print(:y_zp, mnenomic, value), do: "#{mnenomic} $#{hex_value(value, bytes: 1)},Y"
  def print(:zp_ind, mnenomic, value), do: "#{mnenomic} ($#{hex_value(value, bytes: 1)})"
  def print(:x_zp_ind, mnenomic, value), do: "#{mnenomic} ($#{hex_value(value, bytes: 1)},X)"
  def print(:zp_ind_y, mnenomic, value), do: "#{mnenomic} ($#{hex_value(value, bytes: 1)}),Y"
  def print(:rel, mnenomic, value), do: print(:zp, mnenomic, value)

  def hex_value(number, opts \\ []) do
    opts = Keyword.merge([bytes: 2], opts)
    :io_lib.format("~#{opts[:bytes] * 2}.16.0B", [number])
  end

  def little_endian(low, high), do: high <<< 8 ||| low
end

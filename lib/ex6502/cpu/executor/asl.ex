defmodule Ex6502.CPU.Executor.ASL do
  @moduledoc """
  Shift the accumlator or address 1 bit left

  Bit 0 is always 0 and bit 7 pre-shift enters the carry flag.

  ## Operation

  C <- M7...M0 <- 0

  ## Table

  ASL  Shift Left One Bit (Memory or Accumulator)

     C <- [76543210] <- 0             N Z C I D V
                                      + + + - - -

     addressing    assembler    opc  bytes cycles
     --------------------------------------------
     accumulator   ASL A         0A    1     2
     zeropage      ASL oper      06    2     5
     zeropage,X    ASL oper,X    16    2     6
     absolute      ASL oper      0E    3     6
     absolute,X    ASL oper,X    1E    3     7

  ## Flags

  - Carry:    1 if bit 7 was 1; 0 if bit 7 was 0
  - Zero:     1 if accumulator is zero; 0 otherwise
  - Negative: 1 if bit 7 of accumulator is set; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # ASL A $0A
  def execute(%Computer{data_bus: 0x0A} = c) do
    c
    |> CPU.set_flag(:c, c.cpu.a &&& 0b10000000 >>> 7)
    |> CPU.set(:a, c.cpu.a <<< 1 &&& 0xFF)
    |> CPU.set_flags([:n, :z], :a)
  end

  # ASL $nnnn Absolute $0E
  def execute(%Computer{data_bus: 0x0E} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         shifted <- value <<< 1,
         carry <- (shifted &&& 0x100) >>> 8,
         masked <- shifted &&& 0xFF do
      c
      |> Computer.load(c.address_bus, [masked])
      |> CPU.set_flags([:n, :z], masked)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ASL $nnnn,X X-indexed absolute $1E
  def execute(%Computer{data_bus: 0x1E} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c, c.cpu.x),
         shifted <- value <<< 1,
         carry <- (shifted &&& 0x100) >>> 8,
         masked <- shifted &&& 0xFF do
      c
      |> Computer.load(c.address_bus + c.cpu.x, [masked])
      |> CPU.set_flags([:n, :z], masked)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ASL $nn zero-page $06
  def execute(%Computer{data_bus: 0x06} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c),
         shifted <- value <<< 1,
         carry <- (shifted &&& 0x100) >>> 8,
         masked <- shifted &&& 0xFF do
      c
      |> Computer.load(c.address_bus, [masked])
      |> CPU.set_flags([:n, :z], masked)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ASL $xx,X x-indexed zero page $16
  def execute(%Computer{data_bus: 0x16} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c, c.cpu.x),
         shifted <- value <<< 1,
         carry <- shifted &&& 0x100 >>> 8,
         masked <- shifted &&& 0xFF do
      c
      |> Computer.load(c.address_bus + c.cpu.x, [masked])
      |> CPU.set_flags([:n, :z], masked)
      |> CPU.set_flags([:c], carry)
    end
  end
end

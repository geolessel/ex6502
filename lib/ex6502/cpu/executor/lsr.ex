defmodule Ex6502.CPU.Executor.LSR do
  @moduledoc """
  Shift the accumlator or address 1 bit right

  Bit 7 is always 0 and bit 0 pre-shift enters the carry flag.

  ## Operation

  0 -> M7...M0 -> C

  ## Table

  LSR  Shift One Bit Right (Memory or Accumulator)

     0 -> [76543210] -> C             N Z C I D V
                                      0 + + - - -

     addressing    assembler    opc  bytes  cyles
     --------------------------------------------
     accumulator   LSR A         4A    1     2
     zeropage      LSR oper      46    2     5
     zeropage,X    LSR oper,X    56    2     6
     absolute      LSR oper      4E    3     6
     absolute,X    LSR oper,X    5E    3     7

  ## Flags

  - Carry:    1 if bit 0 was 1; 0 if bit 0 was 0
  - Zero:     1 if result is zero; 0 otherwise
  - Negative: 1 if bit 7 of result is set; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # LSR A accumaltor $4A
  def execute(%Computer{data_bus: 0x4A} = c) do
    c
    |> CPU.set_flag(:c, c.cpu.a &&& 0b00000001)
    |> CPU.set(:a, c.cpu.a >>> 1)
    |> CPU.set_flags([:n, :z], :a)
  end

  # ASL $nnnn Absolute $4E
  def execute(%Computer{data_bus: 0x4E} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         shifted <- value >>> 1,
         carry <- value &&& 0x01 do
      c
      |> Computer.load(c.address_bus, [shifted])
      |> CPU.set_flags([:n, :z], shifted)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ASL $nnnn,X X-indexed absolute $5E
  def execute(%Computer{data_bus: 0x5E} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c, c.cpu.x),
         shifted <- value >>> 1,
         carry <- value &&& 0x01 do
      c
      |> Computer.load(c.address_bus + c.cpu.x, [shifted])
      |> CPU.set_flags([:n, :z], shifted)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ASL $nn zero-page $46
  def execute(%Computer{data_bus: 0x46} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c),
         shifted <- value >>> 1,
         carry <- value &&& 0x01 do
      c
      |> Computer.load(c.address_bus, [shifted])
      |> CPU.set_flags([:n, :z], shifted)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ASL $xx,X x-indexed zero page $56
  def execute(%Computer{data_bus: 0x56} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c, c.cpu.x),
         shifted <- value >>> 1,
         carry <- value &&& 0x01 do
      c
      |> Computer.load(c.address_bus + c.cpu.x, [shifted])
      |> CPU.set_flags([:n, :z], shifted)
      |> CPU.set_flags([:c], carry)
    end
  end
end

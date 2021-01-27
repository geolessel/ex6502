defmodule Ex6502.CPU.Executor.ROL do
  @moduledoc """
  Rotate the accumlator or address 1 bit left

  Bit 0 becomes the contents of the carry flag
  and bit 7 pre-shift enters the carry flag.

  ## Operation

  C <- M7...M0 <- C

  ## Table

  ROL  Rotate One Bit Left (Memory or Accumulator)

     C <- [76543210] <- C             N Z C I D V
                                      + + + - - -

     addressing    assembler    opc  bytes  cyles
     --------------------------------------------
     accumulator   ROL A         2A    1     2
     zeropage      ROL oper      26    2     5
     zeropage,X    ROL oper,X    36    2     6
     absolute      ROL oper      2E    3     6
     absolute,X    ROL oper,X    3E    3     7

  ## Flags

  - Carry:    1 if bit 7 was 1; 0 if bit 7 was 0
  - Zero:     1 if result is zero; 0 otherwise
  - Negative: 1 if bit 6 was 1; 0 if bit 7 was 0
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # ROL A accumulator $2A
  def execute(%Computer{data_bus: 0x2A} = c) do
    carry = if CPU.flag(c, :c), do: 1, else: 0

    c
    |> CPU.set(:a, (c.cpu.a <<< 1 ||| carry) &&& 0xFF)
    |> CPU.set_flag(:c, c.cpu.a &&& 0b10000000)
    |> CPU.set_flags([:n, :z], :a)
  end

  # ROL $nnnn Absolute $2E
  def execute(%Computer{data_bus: 0x2E} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         shifted <- value <<< 1,
         carry <- (value &&& 0b10000000) >>> 7,
         previous_carry <- if(CPU.flag(c, :c), do: 1, else: 0),
         masked <- (shifted &&& 0xFF) ||| previous_carry do
      c
      |> Computer.load(c.address_bus, [masked])
      |> CPU.set_flags([:n, :z], masked)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ROL $nnnn,X X-indexed absolute $3E
  def execute(%Computer{data_bus: 0x3E} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c, c.cpu.x),
         shifted <- value <<< 1,
         carry <- (value &&& 0b10000000) >>> 7,
         previous_carry <- if(CPU.flag(c, :c), do: 1, else: 0),
         masked <- (shifted &&& 0xFF) ||| previous_carry do
      c
      |> Computer.load(c.address_bus + c.cpu.x, [masked])
      |> CPU.set_flags([:n, :z], masked)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ROL $nn zero-page $26
  def execute(%Computer{data_bus: 0x26} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c),
         shifted <- value <<< 1,
         carry <- (value &&& 0b10000000) >>> 7,
         previous_carry <- if(CPU.flag(c, :c), do: 1, else: 0),
         masked <- (shifted &&& 0xFF) ||| previous_carry do
      c
      |> Computer.load(c.address_bus, [masked])
      |> CPU.set_flags([:n, :z], masked)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ROL $xx,X x-indexed zero page $36
  def execute(%Computer{data_bus: 0x36} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c, c.cpu.x),
         shifted <- value <<< 1,
         carry <- (value &&& 0b10000000) >>> 7,
         previous_carry <- if(CPU.flag(c, :c), do: 1, else: 0),
         masked <- (shifted &&& 0xFF) ||| previous_carry do
      c
      |> Computer.load(c.address_bus + c.cpu.x, [masked])
      |> CPU.set_flags([:n, :z], masked)
      |> CPU.set_flags([:c], carry)
    end
  end
end

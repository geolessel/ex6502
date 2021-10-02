defmodule Ex6502.CPU.Executor.ROR do
  @moduledoc """
  Rotate the accumlator or address 1 bit right

  Bit 7 becomes the contents of the carry flag
  and bit 0 pre-shift enters the carry flag.

  ## Operation

  C -> M7...M0 -> C

  ## Table

  ROR  Rotate One Bit Right (Memory or Accumulator)

     C -> [76543210] -> C             N Z C I D V
                                      + + + - - -

     addressing    assembler    opc  bytes cycles
     --------------------------------------------
     accumulator   ROR A         6A    1     2
     zeropage      ROR oper      66    2     5
     zeropage,X    ROR oper,X    76    2     6
     absolute      ROR oper      6E    3     6
     absolute,X    ROR oper,X    7E    3     7

  ## Flags

  - Carry:    1 if bit 0 was 1; 0 if bit 0 was 0
  - Zero:     1 if result is zero; 0 otherwise
  - Negative: 1 if bit carry flag was 1; 0 if carry flag was 0
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # ROR A accumulator $6A
  def execute(%Computer{data_bus: 0x6A} = c) do
    carry = if CPU.flag(c, :c), do: 0b10000000, else: 0

    c
    |> CPU.set(:a, c.cpu.a >>> 1 ||| carry)
    |> CPU.set_flag(:c, c.cpu.a &&& 0b00000001)
    |> CPU.set_flags([:n, :z], :a)
  end

  # ROR $nnnn Absolute $6E
  def execute(%Computer{data_bus: 0x6E} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         previous_carry <- if(CPU.flag(c, :c), do: 0b10000000, else: 0),
         shifted <- value >>> 1 ||| previous_carry,
         carry <- value &&& 0b00000001 do
      c
      |> Computer.load(c.address_bus, [shifted])
      |> CPU.set_flags([:n, :z], shifted)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ROR $nnnn,X X-indexed absolute $7E
  def execute(%Computer{data_bus: 0x7E} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c, c.cpu.x),
         previous_carry <- if(CPU.flag(c, :c), do: 0b10000000, else: 0),
         shifted <- value >>> 1 ||| previous_carry,
         carry <- value &&& 0b00000001 do
      c
      |> Computer.load(c.address_bus + c.cpu.x, [shifted])
      |> CPU.set_flags([:n, :z], shifted)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ROR $nn zero-page $66
  def execute(%Computer{data_bus: 0x66} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c),
         previous_carry <- if(CPU.flag(c, :c), do: 0b10000000, else: 0),
         shifted <- value >>> 1 ||| previous_carry,
         carry <- value &&& 0b00000001 do
      c
      |> Computer.load(c.address_bus, [shifted])
      |> CPU.set_flags([:n, :z], shifted)
      |> CPU.set_flags([:c], carry)
    end
  end

  # ROR $xx,X x-indexed zero page $76
  def execute(%Computer{data_bus: 0x76} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c, c.cpu.x),
         previous_carry <- if(CPU.flag(c, :c), do: 0b10000000, else: 0),
         shifted <- value >>> 1 ||| previous_carry,
         carry <- value &&& 0b00000001 do
      c
      |> Computer.load(c.address_bus + c.cpu.x, [shifted])
      |> CPU.set_flags([:n, :z], shifted)
      |> CPU.set_flags([:c], carry)
    end
  end
end

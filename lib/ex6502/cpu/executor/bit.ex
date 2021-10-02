defmodule Ex6502.CPU.Executor.BIT do
  @moduledoc """
  Perform and AND between the location and the accumulator

  Does not affect the accumulator -- only sets specific flags (outlined
  below) based on the AND operation.

  ## Operation

  A ^ M, M7 -> N, M6 -> V

  ## Table

  BIT  Test Bits in Memory with Accumulator

     bits 7 and 6 of operand are transfered to bit 7 and 6 of SR (N,V);
     the zeroflag is set to the result of operand AND accumulator.

     A AND M, M7 -> N, M6 -> V        N Z C I D V
                                     M7 + - - - M6

     addressing    assembler    opc  bytes cycles
     --------------------------------------------
     immediate     BIT #oper     89    2     3
     absolute      BIT oper      2C    3     4
     absolute,X    BIT oper,X    3C    3     4
     zeropage      BIT oper      24    2     3
     zeropage,X    BIT oper      34    2     3


  ## Flags

  - oVerflow: 1 if bit 6 is set; 0 otherwise
  - Zero:     1 if result is zero; 0 otherwise
  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # BIT #$nn Immediate $29
  def execute(%Computer{data_bus: 0x89} = c) do
    with %Computer{data_bus: value} = c <- Computer.put_next_byte_on_data_bus(c),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set_flag(:n, (result &&& 0b10000000) >>> 7)
      |> CPU.set_flag(:v, (result &&& 0b01000000) >>> 6)
      |> CPU.set_flag(:z, result == 0)
    end
  end

  # BIT $nnnn absolute $2C
  def execute(%Computer{data_bus: 0x2C} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set_flag(:n, (result &&& 0b10000000) >>> 7)
      |> CPU.set_flag(:v, (result &&& 0b01000000) >>> 6)
      |> CPU.set_flag(:z, result == 0)
    end
  end

  # BIT $nnnn,X x-indexed absolute $3C
  def execute(%Computer{data_bus: 0x3C} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c, c.cpu.x),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set_flag(:n, (result &&& 0b10000000) >>> 7)
      |> CPU.set_flag(:v, (result &&& 0b01000000) >>> 6)
      |> CPU.set_flag(:z, result == 0)
    end
  end

  # BIT $nn zero page $24
  def execute(%Computer{data_bus: 0x24} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set_flag(:n, (result &&& 0b10000000) >>> 7)
      |> CPU.set_flag(:v, (result &&& 0b01000000) >>> 6)
      |> CPU.set_flag(:z, result == 0)
    end
  end

  # BIT $nn,X x-indexed zero page $34
  def execute(%Computer{data_bus: 0x34} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c, c.cpu.x),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set_flag(:n, (result &&& 0b10000000) >>> 7)
      |> CPU.set_flag(:v, (result &&& 0b01000000) >>> 6)
      |> CPU.set_flag(:z, result == 0)
    end
  end
end

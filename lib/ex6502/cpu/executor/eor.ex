defmodule Ex6502.CPU.Executor.EOR do
  @moduledoc """
  Perform an exclusive OR (XOR) operation with the accumulator eor the location

  Stores the result into the accumulator.

  ## Operation

  A ⊻ M -> A

  ## Table

  EOR  Exclusive-OR Memory with Accumulator

     A EOR M -> A                     N Z C I D V
                                      + + - - - -

     addressing    assembler    opc  bytes  cyles
     --------------------------------------------
     immidiate     EOR #oper     49    2     2
     zeropage      EOR oper      45    2     3
     zeropage,X    EOR oper,X    55    2     4
     absolute      EOR oper      4D    3     4
     absolute,X    EOR oper,X    5D    3     4*
     absolute,Y    EOR oper,Y    59    3     4*
     (indirect,X)  EOR (oper,X)  41    2     6
     (indirect),Y  EOR (oper),Y  51    2     5*

  ## Flags

  - Zero:     1 if result is zero; 0 otherwise
  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # EOR #$nn Immediate $49
  def execute(%Computer{data_bus: 0x49} = c) do
    with %Computer{data_bus: value} = c <- Computer.put_next_byte_on_data_bus(c),
         result <- value ^^^ c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], result)
    end
  end

  # EOR $nnnn Absolute $4d
  def execute(%Computer{data_bus: 0x4D} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         result <- value ^^^ c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # EOR $nnnn,X X-indexed absolute $5d
  def execute(%Computer{data_bus: 0x5D} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c, c.cpu.x),
         result <- value ^^^ c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # EOR $nnnn,Y Y-indexed absolute $59
  def execute(%Computer{data_bus: 0x59} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c, c.cpu.y),
         result <- value ^^^ c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # EOR $nn zero page $45
  def execute(%Computer{data_bus: 0x45} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         result <- value ^^^ c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # EOR $nn,X x-indexed zero page $55
  def execute(%Computer{data_bus: 0x55} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.absolute(c),
         result <- value ^^^ c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # EOR $(nn) zero page indirect $52
  def execute(%Computer{data_bus: 0x52} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c),
         result <- value ^^^ c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # EOR $(nn,X) x-indexed zero page indirect $41
  def execute(%Computer{data_bus: 0x41} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.indirect(c),
         result <- value ^^^ c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # EOR $(nn),Y zero page indirect y-indexed $51
  def execute(%Computer{data_bus: 0x51} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c, c.cpu.y),
         result <- value ^^^ c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end
end

defmodule Ex6502.CPU.Executor.AND do
  @moduledoc """
  Transfer to the adder and perform a bit-by-bit AND operation

  ## Operation

  A ^ M -> A

  ## Table

  AND  AND Memory with Accumulator

     A AND M -> A                     N Z C I D V
                                      + + - - - -

     addressing    assembler    opc  bytes  cyles
     --------------------------------------------
     immidiate     AND #oper     29    2     2
     zeropage      AND oper      25    2     3
     zeropage,X    AND oper,X    35    2     4
     absolute      AND oper      2D    3     4
     absolute,X    AND oper,X    3D    3     4*
     absolute,Y    AND oper,Y    39    3     4*
     (indirect,X)  AND (oper,X)  21    2     6
     (indirect),Y  AND (oper),Y  31    2     5*

  ## Flags

  - Zero:     1 if result is zero; 0 otherwise
  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # AND #$nn Immediate $29
  def execute(%Computer{data_bus: 0x29} = c) do
    with %Computer{data_bus: value} = c <- Computer.put_next_byte_on_data_bus(c),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # AND $nnnn Absolute $2d
  def execute(%Computer{data_bus: 0x2D} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # AND $nnnn,X X-indexed absolute $3d
  def execute(%Computer{data_bus: 0x3D} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c, c.cpu.x),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # AND $nnnn,Y Y-indexed absolute $39
  def execute(%Computer{data_bus: 0x39} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c, c.cpu.y),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # AND $nn zero page $25
  def execute(%Computer{data_bus: 0x25} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # AND $nn,X x-indexed zero page $35
  def execute(%Computer{data_bus: 0x35} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.absolute(c),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # AND $(nn) zero page indirect $32
  def execute(%Computer{data_bus: 0x32} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # AND $(nn,X) x-indexed zero page indirect $21
  def execute(%Computer{data_bus: 0x21} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.indirect(c),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # AND $(nn),Y zero page indirect y-indexed $31
  def execute(%Computer{data_bus: 0x31} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c, c.cpu.y),
         result <- value &&& c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end
end

defmodule Ex6502.CPU.Executor.ORA do
  @moduledoc """
  Perform an OR operation with the accumulator or a the location

  Stores the result into the accumulator.

  ## Operation

  A ∨ M -> A

  ## Table

  ORA  Exclusive-OR Memory with Accumulator

     A ORA M -> A                      N Z C I D V
                                       + + - - - -

     addressing    assembler    opc  bytes  cycles
     ---------------------------------------------
     immediate     ORA #oper     09    2     2
     zeropage      ORA oper      05    2     3
     zeropage,X    ORA oper,X    15    2     4
     absolute      ORA oper      0D    3     4
     absolute,X    ORA oper,X    1D    3     4*
     absolute,Y    ORA oper,Y    19    3     4*
     (indirect,X)  ORA (oper,X)  01    2     6
     (indirect),Y  ORA (oper),Y  11    2     5*

  ## Flags

  - Zero:     1 if result is zero; 0 otherwise
  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # ORA #$nn Immediate $09
  def execute(%Computer{data_bus: 0x09} = c) do
    with %Computer{data_bus: value} = c <- Computer.put_next_byte_on_data_bus(c),
         result <- value ||| c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], result)
    end
  end

  # ORA $nnnn Absolute $0D
  def execute(%Computer{data_bus: 0x0D} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         result <- value ||| c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # ORA $nnnn,X X-indexed absolute $1D
  def execute(%Computer{data_bus: 0x1D} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c, c.cpu.x),
         result <- value ||| c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # ORA $nnnn,Y Y-indexed absolute $19
  def execute(%Computer{data_bus: 0x19} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c, c.cpu.y),
         result <- value ||| c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # ORA $nn zero page $05
  def execute(%Computer{data_bus: 0x05} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c),
         result <- value ||| c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # ORA $nn,X x-indexed zero page $15
  def execute(%Computer{data_bus: 0x15} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.absolute(c),
         result <- value ||| c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # ORA $(nn) zero page indirect $12
  def execute(%Computer{data_bus: 0x12} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c),
         result <- value ||| c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # ORA $(nn,X) x-indexed zero page indirect $01
  def execute(%Computer{data_bus: 0x01} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.indirect(c),
         result <- value ||| c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end

  # ORA $(nn),Y zero page indirect y-indexed $11
  def execute(%Computer{data_bus: 0x11} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c, c.cpu.y),
         result <- value ||| c.cpu.a do
      c
      |> CPU.set(:a, result)
      |> CPU.set_flags([:n, :z], :a)
    end
  end
end

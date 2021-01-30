defmodule Ex6502.CPU.Executor.CMP do
  @moduledoc """
  Subtracts the contents of memory from the contents of the accumulator, affecting flags

  ## Operation

  A - M

  ## Table

      CMP | Compare Memory and Accumulator
      ================================================

      A - M                            N V - B D I Z C
                                       + - - - - - + +

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      immediate        CMP #$nn      C9    2     2
      absolute         CMP $nnnn     CD    3     4
      absolute,X       CMP $nnnn,X   DD    3     4 p
      absolute,Y       CMP $nnnn,Y   D9    3     4 p
      zeropage         CMP $nn       C5    2     3
      zeropage,X       CMP $nn,X     D5    2     4
      (zp indirect)    CMP ($nn)     D2    2     5
      (zp indirect,X)  CMP ($nn,X)   C1    2     6
      (zp indirect),Y  CMP ($nn),Y   D1    2     5 p

      p: +1 if page is crossed

  ## Flags

  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  - Carry:    1 if sum of binary exceeds 255 or decimal add exceeds 99; 0 otherwise
  - Zero:     1 if memory is <= accumulator; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  def execute(%Computer{} = c) do
    c
    |> do_execute()
    |> set_flags()
  end

  def set_flags({%Computer{} = c, value}) do
    result = c.cpu.a - value

    c
    |> CPU.set_flag(:c, value <= c.cpu.a)
    |> CPU.set_flags([:n, :z], result)
  end

  # addressing       assembler    opc  bytes  cycles
  # immediate        CMP #$nn      C9    2     2
  def do_execute(%Computer{data_bus: 0xC9} = c) do
    with %Computer{data_bus: value} = c <- Computer.put_next_byte_on_data_bus(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute         CMP $nnnn     CD    3     4
  def do_execute(%Computer{data_bus: 0xCD} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute,X       CMP $nnnn,X   DD    3     4 p
  def do_execute(%Computer{data_bus: 0xDD} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c, c.cpu.x) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute,Y       CMP $nnnn,Y   D9    3     4 p
  def do_execute(%Computer{data_bus: 0xD9} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c, c.cpu.y) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # zeropage         CMP $nn       C5    2     3
  def do_execute(%Computer{data_bus: 0xC5} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # zeropage,X       CMP $nn,X     D5    2     4
  def do_execute(%Computer{data_bus: 0xD5} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.absolute(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # (zp indirect)    CMP ($nn)     D2    2     5 d
  def do_execute(%Computer{data_bus: 0xD2} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # (zp indirect,X)  CMP ($nn,X)   C1    2     6
  def do_execute(%Computer{data_bus: 0xC1} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.indirect(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # (zp indirect),Y  CMP ($nn),Y   D1    2     5 p
  def do_execute(%Computer{data_bus: 0xD1} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c, c.cpu.y) do
      {c, value}
    end
  end
end

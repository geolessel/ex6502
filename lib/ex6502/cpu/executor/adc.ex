defmodule Ex6502.CPU.Executor.ADC do
  @moduledoc """
  Add the value of memory and carry to accumulator storing result in accumulator

  ## Operation

  A + M + C -> A, C

  ## Table

      ADC | Add Memory to Accumulator with Carry
      ================================================

      A + M + C -> A, C                N V - B D I Z C
                                       + + - - - - + +

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      immediate        ADC #$nn      69    2     2 d
      absolute         ADC $nnnn     6D    3     4 d
      absolute,X       ADC $nnnn,X   7D    3     4 dp
      absolute,Y       ADC $nnnn,Y   79    3     4 dp
      zeropage         ADC $nn       65    2     3 d
      zeropage,X       ADC $nn,X     75    2     4 d
      (zp indirect)    ADC ($nn)     72    2     5 d
      (zp indirect,X)  ADC ($nn,X)   61    2     6 d
      (zp indirect),Y  ADC ($nn),Y   71    2     5 dp

      p: +1 if page is crossed
      d: +1 if in decimal mode

  ## Flags

  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  - oVerflow: 1 when the sign of bit 7 is changed due to exceeding +127 or -128; else 0
  - Carry:    1 if sum of binary exceeds 255 or decimal add exceeds 99; else 0
  - Zero:     1 if result is zero; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  def execute(%Computer{} = c) do
    if CPU.flag(c, :d), do: raise(RuntimeError, "Decimal mode is not yet supported")

    c
    |> do_execute()
    |> set_flags()
  end

  def set_flags({%Computer{} = c, value}) do
    result = value + c.cpu.a
    masked = result &&& 0xFF

    c
    |> CPU.set(:a, masked)
    |> CPU.set_flag(:c, result > 0xFF)
    |> CPU.set_flag(:v, (value &&& 0x80) != (masked &&& 0x80))
    |> CPU.set_flags([:n, :z], :a)
  end

  # addressing       assembler    opc  bytes  cycles
  # immediate        ADC #$nn      69    2     2 d
  def do_execute(%Computer{data_bus: 0x69} = c) do
    with %Computer{data_bus: value} = c <- Computer.put_next_byte_on_data_bus(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute         ADC $nnnn     6D    3     4 d
  def do_execute(%Computer{data_bus: 0x6D} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute,X       ADC $nnnn,X   7D    3     4 dp
  def do_execute(%Computer{data_bus: 0x7D} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c, c.cpu.x) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute,Y       ADC $nnnn,Y   79    3     4 dp
  def do_execute(%Computer{data_bus: 0x79} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c, c.cpu.y) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # zeropage         ADC $nn       65    2     3 d
  def do_execute(%Computer{data_bus: 0x65} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # zeropage,X       ADC $nn,X     75    2     4 d
  def do_execute(%Computer{data_bus: 0x75} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.absolute(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # (zp indirect)    ADC ($nn)     72    2     5 d
  def do_execute(%Computer{data_bus: 0x72} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # (zp indirect,X)  ADC ($nn,X)   61    2     6 d
  def do_execute(%Computer{data_bus: 0x61} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.indirect(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # (zp indirect),Y  ADC ($nn),Y   71    2     5 dp
  def do_execute(%Computer{data_bus: 0x71} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c, c.cpu.y) do
      {c, value}
    end
  end
end

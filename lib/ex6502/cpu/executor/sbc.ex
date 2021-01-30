defmodule Ex6502.CPU.Executor.SBC do
  @moduledoc """
  Subtract the value of memory and borrow (carry) from accumulator storing result in accumulator

  A set carry flag means that a "borrow" was not required during the subtraction operation

  ## Operation

  A - M - ~C -> A

  ## Table

      SBC | Subtract Memory From Accumulator with Borrow
      ==================================================

      A - M - ~C -> A                  N V - B D I Z C
                                       + + - - - - + +

      addressing       assembler    opc  bytes  cycles
      --------------------------------------------------
      immediate        SBC #$nn      E9    2     2 d
      absolute         SBC $nnnn     ED    3     4 d
      absolute,X       SBC $nnnn,X   FD    3     4 dp
      absolute,Y       SBC $nnnn,Y   F9    3     4 dp
      zeropage         SBC $nn       E5    2     3 d
      zeropage,X       SBC $nn,X     F5    2     4 d
      (zp indirect)    SBC ($nn)     F2    2     5 d
      (zp indirect,X)  SBC ($nn,X)   E1    2     6 d
      (zp indirect),Y  SBC ($nn),Y   F1    2     5 dp

      p: +1 if page is crossed
      d: +1 if in decimal mode

  ## Flags

  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  - oVerflow: 1 when the sign of bit 7 is changed due to exceeding +127 or -128; else 0
  - Carry:    1 if result is >= 0; 0 otherwise
  - Zero:     1 if result is zero; 0 otherwise

  ## Further reference

  - http://www.righto.com/2012/12/the-6502-overflow-flag-explained.html
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  def execute(%Computer{} = c) do
    c
    |> do_execute()
    |> set_flags()
  end

  def set_flags({%Computer{} = c, value}) do
    carry_value = if CPU.flag(c, :c), do: 1, else: 0
    <<complement::unsigned>> = <<(~~~value + 1)>>

    # subtraction is really addition with the complement
    <<carry::integer-1, result::unsigned-integer-8>> =
      <<c.cpu.a + complement + (1 - carry_value)::integer-9>>

    masked = result &&& 0xFF

    c
    |> CPU.set(:a, masked)
    |> CPU.set_flag(:c, carry)
    # not sure I totally understand this.
    #
    # From "6502 User's Manual" by Joseph Carr:
    # the overflow flag (V) is HIGH when the result exceeds the values
    # 7FH (+ 127,0) and 80H with C = 1 (i.e., ‐12810).
    #
    # see www.righto.com/2012/12/the-6502-overflow-flag-explained.html
    |> CPU.set_flag(:v, (c.cpu.a ^^^ result &&& (255 - value) ^^^ result &&& 0x80) != 0)
    |> CPU.set_flags([:n, :z], :a)
  end

  # addressing       assembler    opc  bytes  cycles
  # immediate        SBC #$nn      E9    2     2 d
  def do_execute(%Computer{data_bus: 0xE9} = c) do
    with %Computer{data_bus: value} = c <- Computer.put_next_byte_on_data_bus(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute         SBC $nnnn     ED    3     4 d
  def do_execute(%Computer{data_bus: 0xED} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute,X       SBC $nnnn,X   FD    3     4 dp
  def do_execute(%Computer{data_bus: 0xFD} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c, c.cpu.x) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute,Y       SBC $nnnn,Y   F9    3     4 dp
  def do_execute(%Computer{data_bus: 0xF9} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c, c.cpu.y) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # zeropage         SBC $nn       E5    2     3 d
  def do_execute(%Computer{data_bus: 0xE5} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # zeropage,X       SBC $nn,X     F5    2     4 d
  def do_execute(%Computer{data_bus: 0xF5} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.absolute(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # (zp indirect)    SBC ($nn)     F2    2     5 d
  def do_execute(%Computer{data_bus: 0xF2} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # (zp indirect,X)  SBC ($nn,X)   E1    2     6 d
  def do_execute(%Computer{data_bus: 0xE1} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c, c.cpu.x),
         %Computer{data_bus: value} <- Memory.indirect(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # (zp indirect),Y  SBC ($nn),Y   F1    2     5 dp
  def do_execute(%Computer{data_bus: 0xF1} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.indirect(c, c.cpu.y) do
      {c, value}
    end
  end
end

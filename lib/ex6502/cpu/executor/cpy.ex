defmodule Ex6502.CPU.Executor.CPY do
  @moduledoc """
  Subtracts the contents of the Y register from the memory only affecting flags

  ## Operation

  Y - M

  ## Table

      CPY | Compare Index Register Y to Memory
      ================================================

      Y - M                            N V - B D I Z C
                                       + - - - - - + +

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      immediate        CPY #$nn      C0    2     2
      absolute         CPY $nnnn     CC    3     4
      zeropage         CPY $nn       C4    2     3

  ## Flags

  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  - Carry:    1 if X >= M; 0 otherwise
  - Zero:     1 if X == M; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  def execute(%Computer{} = c) do
    c
    |> do_execute()
    |> set_flags()
  end

  def set_flags({%Computer{} = c, value}) do
    result = c.cpu.y - value

    c
    |> CPU.set_flag(:c, c.cpu.y >= value)
    |> CPU.set_flags([:n, :z], result)
  end

  # addressing       assembler    opc  bytes  cycles
  # immediate        CPY #$nn      C0    2     2
  def do_execute(%Computer{data_bus: 0xC0} = c) do
    with %Computer{data_bus: value} = c <- Computer.put_next_byte_on_data_bus(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute         CPY $nnnn     CC    3     4
  def do_execute(%Computer{data_bus: 0xCC} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c) do
      {c, value}
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # zeropage         CPY $nn       C4    2     3
  def do_execute(%Computer{data_bus: 0xC4} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} <- Memory.absolute(c) do
      {c, value}
    end
  end
end

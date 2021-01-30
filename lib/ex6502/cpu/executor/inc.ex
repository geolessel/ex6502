defmodule Ex6502.CPU.Executor.INC do
  @moduledoc """
  Add 1 to the memory location

  ## Operation

  M + 1 -> M

  ## Table

      INC | Increment Memory by One
      ================================================

      M + 1 -> M                       N V - B D I Z C
                                       + - - - - - + -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      accumulator      INC           1A    1     2
      absolute         INC $nnnn     EE    3     6
      absolute,X       INC $nnnn,X   FE    3     7
      zeropage         INC $nn       E6    2     5
      zeropage,X       INC $nn,X     F6    2     6

  ## Flags

  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  - Zero:     1 if result is zero; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # This is a special mode that needs its own special function
  #
  # addressing       assembler    opc  bytes  cycles
  # accumulator      INC           1A    1     2
  def execute(%Computer{data_bus: 0x1A} = c) do
    # subtraction is really addition with the complement
    result = c.cpu.a + 1 &&& 0xFF

    c
    |> CPU.set(:a, result)
    |> CPU.set_flags([:n, :z], result)
  end

  def execute(%Computer{} = c) do
    c
    |> do_execute()
    |> set_flags()
  end

  def set_flags(%Computer{address_bus: address} = c) do
    with value <- Memory.get(c.memory, address) do
      result = value + 1 &&& 0xFF

      c
      |> Computer.load(address, [result])
      |> CPU.set_flags([:n, :z], result)
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute         INC $nnnn     EE    3      6
  def do_execute(%Computer{data_bus: 0xEE} = c), do: Computer.put_absolute_address_on_bus(c)

  # addressing       assembler    opc  bytes  cycles
  # absolute,X       INC $nnnn,X   FE    3      7
  def do_execute(%Computer{data_bus: 0xFE} = c),
    do: Computer.put_absolute_address_on_bus(c, c.cpu.x)

  # addressing       assembler    opc  bytes  cycles
  # zeropage         INC $nn       E6    2      5
  def do_execute(%Computer{data_bus: 0xE6} = c), do: Computer.put_zero_page_on_address_bus(c)

  # addressing       assembler    opc  bytes  cycles
  # zeropage,X       INC $nn,X     F6    2      6
  def do_execute(%Computer{data_bus: 0xF6} = c),
    do: Computer.put_zero_page_on_address_bus(c, c.cpu.x)
end

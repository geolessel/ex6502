defmodule Ex6502.CPU.Executor.DEC do
  @moduledoc """
  Subtract 1, in two's complement, from the memory location

  ## Operation

  M - 1 -> M

  ## Table

      DEC | Decrement Memory by One
      ================================================

      M - 1 -> M                       N V - B D I Z C
                                       + - - - - - + -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      accumulator      DEC           3A    1     2
      absolute         DEC $nnnn     CE    3     6
      absolute,X       DEC $nnnn,X   DE    3     7
      zeropage         DEC $nn       C6    2     5
      zeropage,X       DEC $nn,X     D6    2     6

  ## Flags

  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  - Zero:     1 if result is zero; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # This is a special mode that needs its own special function
  #
  # addressing       assembler    opc  bytes  cycles
  # accumulator      DEC           3A    1      1
  def execute(%Computer{data_bus: 0x3A} = c) do
    # subtraction is really addition with the complement
    <<result::unsigned>> = <<c.cpu.a + (~~~0x01 + 1)>>

    c
    |> CPU.set(:a, result)
    |> CPU.set_flags([:n, :z], :a)
  end

  def execute(%Computer{} = c) do
    c
    |> do_execute()
    |> set_flags()
  end

  def set_flags(%Computer{address_bus: address} = c) do
    with value <- Memory.get(c.memory, address) do
      # subtraction is really addition with the complement
      <<result::unsigned>> = <<value + (~~~0x01 + 1)>>

      c
      |> Computer.load(address, [result])
      |> CPU.set_flags([:n, :z], result)
    end
  end

  # addressing       assembler    opc  bytes  cycles
  # absolute         DEC $nnnn     CE    3      6
  def do_execute(%Computer{data_bus: 0xCE} = c), do: Computer.put_absolute_address_on_bus(c)

  # addressing       assembler    opc  bytes  cycles
  # absolute,X       DEC $nnnn,X   DE    3      7
  def do_execute(%Computer{data_bus: 0xDE} = c),
    do: Computer.put_absolute_address_on_bus(c, c.cpu.x)

  # addressing       assembler    opc  bytes  cycles
  # zeropage         DEC $nn       C6    2      5
  def do_execute(%Computer{data_bus: 0xC6} = c), do: Computer.put_zero_page_on_address_bus(c)

  # addressing       assembler    opc  bytes  cycles
  # zeropage,X       DEC $nn,X     D6    2      6
  def do_execute(%Computer{data_bus: 0xD6} = c),
    do: Computer.put_zero_page_on_address_bus(c, c.cpu.x)
end

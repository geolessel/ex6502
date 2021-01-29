defmodule Ex6502.CPU.Executor.TSB do
  @moduledoc """
  Test and sets bits in memory, using the accumulator as a test and set mask.

  Performs a logical OR between the inverted bits of the accumulator and the
  bits in memory, storing the result back into memory.

  ## Operation

  A ∨ M -> M

  ## Table

  TSB  Test and Set Memory Bits with Accumulator

     A TSB M -> A                     N Z C I D V
                                      - + - - - -

     addressing    assembler    opc  bytes  cyles
     --------------------------------------------
     absolute      TSB oper      0C    3     6
     zeropage      TSB oper      04    2     5

  ## Flags

  - Zero:     1 if result is zero; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # TSB $nnnn absolute $0C
  def execute(%Computer{data_bus: 0x0C} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c),
         result <- value ||| c.cpu.a do
      c
      |> Computer.load(c.address_bus, [result])
      |> CPU.set_flag(:z, result == 0)
    end
  end

  # TSB $nn zero page $04
  def execute(%Computer{data_bus: 0x04} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c),
         result <- value ||| c.cpu.a do
      c
      |> Computer.load(c.address_bus, [result])
      |> CPU.set_flag(:z, result == 0)
    end
  end
end

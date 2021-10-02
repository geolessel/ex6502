defmodule Ex6502.CPU.Executor.TRB do
  @moduledoc """
  Test and reset bits in memory, using the accumulator as a test and reset mask.

  Performs a logical AND between the inverted bits of the accumulator and the
  bits in memory, storing the result back into memory.

  ## Operation

  ~A ∧ M -> M

  ## Table

  TRB  Test and Reset Memory Bits with Accumulator

     A TRB M -> A                     N Z C I D V
                                      - + - - - -

     addressing    assembler    opc  bytes cycles
     --------------------------------------------
     zeropage      TRB oper      14    2     6
     absolute      TRB oper      1C    3     5

  ## Flags

  - Zero:     1 if result is zero; 0 otherwise
  """

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  # TRB $nnnn absolute $1C
  def execute(%Computer{data_bus: 0x1C} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c),
         result <- value &&& ~~~c.cpu.a do
      c
      |> Computer.load(c.address_bus, [result])
      |> CPU.set_flag(:z, result == 0)
    end
  end

  # TRB $nn zero page $14
  def execute(%Computer{data_bus: 0x14} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c),
         %Computer{data_bus: value} = c <- Memory.absolute(c),
         result <- value &&& ~~~c.cpu.a do
      c
      |> Computer.load(c.address_bus, [result])
      |> CPU.set_flag(:z, result == 0)
    end
  end
end

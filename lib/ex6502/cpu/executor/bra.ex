defmodule Ex6502.CPU.Executor.BRA do
  @moduledoc """
  Unconditional branch

  ## Table

      BRA | Increment Memory by One
      ================================================

                                       N V - B D I Z C
                                       - - - - - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      relative         BRA $nnnn    80     2     3 tp

      p: +1 if page is crossed
      t: +1 if branch is taken

  ## Flags

  - Negative: 1 if bit 7 of result is 1; 0 otherwise
  - Zero:     1 if result is zero; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  use Bitwise

  # addressing       assembler    opc  bytes  cycles
  # relative         BRA $nnnn    80     2     3 tp
  def execute(%Computer{data_bus: 0x80} = c) do
    with %Computer{address_bus: address} = c <- Computer.put_absolute_address_on_bus(c) do
      <<_unused::integer-8, offset::signed-integer-8>> = <<address::integer-16>>
      CPU.set(c, :pc, c.cpu.pc + offset)
    end
  end
end

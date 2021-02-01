defmodule Ex6502.CPU.Executor.JSR do
  @moduledoc """
  Transfer control of the PC to a subroutine location

  Leaves a return pointer on the stack high byte first.

  ## Operation

  PC + 2↓
  [PC + 1] → PCL
  [PC + 2] → PCH

  ## Table

      JSR | Jump to Subroutine
      ==================================================

      PC + 2↓                            N V - B D I Z C
      [PC + 1] → PCL                    - - - - - - - -
      [PC + 2] → PCH

      addressing       assembler      opc  bytes  cycles
      --------------------------------------------------
      absolute         JSR $nnnn       20    3      6
  """

  alias Ex6502.{Computer, CPU}

  # addressing       assembler      opc  bytes  cycles
  # absolute         JSR $nnnn       20    3      6
  def execute(%Computer{data_bus: 0x20} = c) do
    with c <- Computer.put_absolute_address_on_bus(c) do
      <<high::integer-8, low::integer-8>> = <<c.cpu.pc - 1::integer-16>>

      c
      |> CPU.Stack.push(high)
      |> CPU.Stack.push(low)
      |> CPU.set(:pc, c.address_bus)
    end
  end
end

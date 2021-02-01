defmodule Ex6502.CPU.Executor.BRK do
  @moduledoc """
  Break

  The program counter of the second byte after the BRK is automatically stored
  on the stack along with the process status at the beginning of the instruction.
  The control is then transferred to the interrupt vector (FFFE-FFFF).

  After the operation, the stack will be (if nothing else is on the stack)

      0x01fd  Status register with B set
      0x01fe  PCL
      0x01ff  PCH
      ===========

  ## Operation

  PC + 2 ↓, [FFFE] → PCL, [FFFF] → PCH

  ## Table

      BRK | Break
      ================================================

      PC + 2 ↓, [FFFE] → PCL          N V - B D I Z C
                [FFFF] → PCH          - - - 1 - - - -

      addressing       assembler    opc  bytes  cycles
      ------------------------------------------------
      implied          BRK           00    1      7

  ## Flags

  - Interrupt: always 1
  """

  alias Ex6502.{Computer, CPU}

  use Bitwise

  def execute(%Computer{data_bus: 0x00} = c) do
    # flow from https://www.pagetable.com/?p=410

    <<high::integer-8, low::integer-8>> = <<c.cpu.pc::integer-16>>

    c
    |> CPU.Stack.push(high)
    |> CPU.Stack.push(low)
    # set B flag
    |> CPU.Stack.push(c.cpu.p ||| 0x10)
    |> CPU.set(:pc, 0xFFFE)
    |> Map.put(:running, false)
  end
end

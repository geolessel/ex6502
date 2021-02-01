defmodule Ex6502.CPU.Executor.JMP do
  @moduledoc """
  Change program counter to memory value

  ## Operation

  [PC + 1] → PCL
  [PC + 2] → PCH

  ## Table

      JMP | Jump Indirect
      ==================================================

      [PC + 1] → PCL                    N V - B D I Z C
      [PC + 2] → PCH                    - - - - - - - -

      addressing       assembler      opc  bytes  cycles
      --------------------------------------------------
      absolute         JMP $nnnn       4C    3      3
      (indirect)       JMP ($nnnn)     6C    3      6
      (indirect,X)     JMP ($nnnn,X)   7C    3      6
  """

  alias Ex6502.{Computer, CPU, Memory}

  # addressing       assembler      opc  bytes  cycles
  # absolute         JMP $nnnn       4C    3      3
  def execute(%Computer{data_bus: 0x4C} = c) do
    with c <- Computer.put_absolute_address_on_bus(c) do
      CPU.set(c, :pc, c.address_bus)
    end
  end

  # addressing       assembler      opc  bytes  cycles
  # (indirect)       JMP ($nnnn)     6C    3      6
  def execute(%Computer{data_bus: 0x6C} = c) do
    with c <- Computer.put_absolute_address_on_bus(c),
         c <- Memory.indirect(c) do
      CPU.set(c, :pc, c.address_bus)
    end
  end

  # addressing       assembler      opc  bytes  cycles
  # (indirect,X)     JMP ($nnnn,X)   7C    3      6
  def execute(%Computer{data_bus: 0x7C} = c) do
    with c <- Computer.put_absolute_address_on_bus(c, c.cpu.x),
         c <- Memory.indirect(c) do
      CPU.set(c, :pc, c.address_bus)
    end
  end
end

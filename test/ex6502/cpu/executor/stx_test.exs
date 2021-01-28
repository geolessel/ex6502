defmodule Ex6502.CPU.Executor.STXTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.STX
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "STX" do
    test "$nnnn absolute $8E", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x8E, 0x50, 0x85])
        |> setup_computer_for(0x8E)
        |> CPU.set(:x, 0x99)
        |> STX.execute()

      assert Memory.get(c.memory, 0x8550) == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$nn zero page $86", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x86, 0x50])
        |> setup_computer_for(0x86)
        |> CPU.set(:x, 0x99)
        |> STX.execute()

      assert Memory.get(c.memory, 0x0050) == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$nn,Y y-indexed zero page $96", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x96, 0x50])
        |> setup_computer_for(0x96)
        |> CPU.set(:y, 0x33)
        |> CPU.set(:x, 0x99)
        |> STX.execute()

      assert Memory.get(c.memory, 0x0083) == 0x99
      assert c.cpu.pc == 0x8002
    end
  end
end

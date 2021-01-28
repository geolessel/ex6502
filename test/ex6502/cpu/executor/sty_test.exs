defmodule Ex6502.CPU.Executor.STYTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.STY
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "STY" do
    test "$nnnn absolute $8C", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x8C, 0x50, 0x85])
        |> setup_computer_for(0x8C)
        |> CPU.set(:y, 0x99)
        |> STY.execute()

      assert Memory.get(c.memory, 0x8550) == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$nn zero page $84", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x84, 0x50])
        |> setup_computer_for(0x84)
        |> CPU.set(:y, 0x99)
        |> STY.execute()

      assert Memory.get(c.memory, 0x0050) == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$nn,X x-indexed zero page $94", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x94, 0x50])
        |> setup_computer_for(0x94)
        |> CPU.set(:x, 0x33)
        |> CPU.set(:y, 0x99)
        |> STY.execute()

      assert Memory.get(c.memory, 0x0083) == 0x99
      assert c.cpu.pc == 0x8002
    end
  end
end

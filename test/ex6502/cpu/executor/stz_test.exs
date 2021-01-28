defmodule Ex6502.CPU.Executor.STZTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.STZ
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "STZ" do
    test "$nnnn absolute $9c", %{c: c} do
      c =
        c
        |> setup_computer_for(0x9C)
        |> Computer.load(0x8000, [0x9C, 0x50, 0x85])
        |> Computer.load(0x8550, [0x99])
        |> STZ.execute()

      assert Memory.get(c.memory, 0x8550) == 0
      assert c.cpu.pc == 0x8003
    end

    test "$nnnn,X absolute $9e", %{c: c} do
      c =
        c
        |> setup_computer_for(0x9E)
        |> Computer.load(0x8000, [0x9E, 0x50, 0x85])
        |> Computer.load(0x8550, [0x99])
        |> CPU.set(:x, 0x09)
        |> STZ.execute()

      assert Memory.get(c.memory, 0x8559) == 0
      assert c.cpu.pc == 0x8003
    end

    test "$nn zero page $64", %{c: c} do
      c =
        c
        |> setup_computer_for(0x64)
        |> Computer.load(0x8000, [0x64, 0x50])
        |> Computer.load(0x0050, [0x99])
        |> STZ.execute()

      assert Memory.get(c.memory, 0x0050) == 0
      assert c.cpu.pc == 0x8002
    end

    test "$nn,X x-indexed zero page $74", %{c: c} do
      c =
        c
        |> setup_computer_for(0x74)
        |> Computer.load(0x8000, [0x74, 0x50])
        |> Computer.load(0x0059, [0x99])
        |> CPU.set(:x, 0x09)
        |> STZ.execute()

      assert Memory.get(c.memory, 0x0059) == 0
      assert c.cpu.pc == 0x8002
    end
  end
end

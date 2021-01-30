defmodule Ex6502.CPU.Executor.DECTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.DEC
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "DEC" do
    test "accumulator $3A", %{c: c} do
      c =
        c
        |> setup_computer_for(0x3A)
        |> Computer.load(0x8000, [0x3A])
        |> CPU.set(:a, 0x00)
        |> DEC.execute()

      assert c.cpu.pc == 0x8001
      assert c.cpu.a == 0xFF
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
    end

    test "$nnnn absolute $CE", %{c: c} do
      c =
        c
        |> setup_computer_for(0xCE)
        |> Computer.load(0x8000, [0xCE, 0x50, 0x80])
        |> Computer.load(0x8050, [0x70])
        |> DEC.execute()

      assert c.cpu.pc == 0x8003
      assert Memory.get(c.memory, 0x8050) == 0x6F
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
    end

    test "$nnnn,X x-indexed absolute $DE", %{c: c} do
      c =
        c
        |> setup_computer_for(0xDE)
        |> Computer.load(0x8000, [0xDE, 0x50, 0x80])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x8055, [0x01])
        |> DEC.execute()

      assert c.cpu.pc == 0x8003
      assert Memory.get(c.memory, 0x8055) == 0x00
      assert CPU.flag(c, :z) == true
      assert CPU.flag(c, :n) == false
    end

    test "$nn zero page $C6", %{c: c} do
      c =
        c
        |> setup_computer_for(0xC6)
        |> Computer.load(0x8000, [0xC6, 0x50])
        |> Computer.load(0x0050, [0xFF])
        |> DEC.execute()

      assert c.cpu.pc == 0x8002
      assert Memory.get(c.memory, 0x0050) == 0xFE
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
    end

    test "$nn,X x-indexed zero page $D6", %{c: c} do
      c =
        c
        |> setup_computer_for(0xD6)
        |> Computer.load(0x8000, [0xD6, 0x50])
        |> CPU.set(:x, 0x09)
        |> Computer.load(0x0059, [0x05])
        |> DEC.execute()

      assert c.cpu.pc == 0x8002
      assert Memory.get(c.memory, 0x0059) == 0x04
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
    end
  end
end

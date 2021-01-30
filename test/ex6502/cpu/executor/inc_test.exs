defmodule Ex6502.CPU.Executor.INCTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.INC
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "INC" do
    test "accumulator $1A", %{c: c} do
      c =
        c
        |> setup_computer_for(0x1A)
        |> Computer.load(0x8000, [0x1A])
        |> CPU.set(:a, 0xFF)
        |> INC.execute()

      assert c.cpu.pc == 0x8001
      assert c.cpu.a == 0x00
      assert CPU.flag(c, :z) == true
      assert CPU.flag(c, :n) == false
    end

    test "$nnnn absolute $EE", %{c: c} do
      c =
        c
        |> setup_computer_for(0xEE)
        |> Computer.load(0x8000, [0xEE, 0x50, 0x80])
        |> Computer.load(0x8050, [0x7F])
        |> INC.execute()

      assert c.cpu.pc == 0x8003
      assert Memory.get(c.memory, 0x8050) == 0x80
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
    end

    test "$nnnn,X x-indexed absolute $FE", %{c: c} do
      c =
        c
        |> setup_computer_for(0xFE)
        |> Computer.load(0x8000, [0xFE, 0x50, 0x80])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x8055, [0x31])
        |> INC.execute()

      assert c.cpu.pc == 0x8003
      assert Memory.get(c.memory, 0x8055) == 0x32
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
    end

    test "$nn zero page $E6", %{c: c} do
      c =
        c
        |> setup_computer_for(0xE6)
        |> Computer.load(0x8000, [0xE6, 0x50])
        |> Computer.load(0x0050, [0xEF])
        |> INC.execute()

      assert c.cpu.pc == 0x8002
      assert Memory.get(c.memory, 0x0050) == 0xF0
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
    end

    test "$nn,X x-indexed zero page $F6", %{c: c} do
      c =
        c
        |> setup_computer_for(0xF6)
        |> Computer.load(0x8000, [0xF6, 0x50])
        |> CPU.set(:x, 0x09)
        |> Computer.load(0x0059, [0x05])
        |> INC.execute()

      assert c.cpu.pc == 0x8002
      assert Memory.get(c.memory, 0x0059) == 0x06
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
    end
  end
end

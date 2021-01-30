defmodule Ex6502.CPU.Executor.CMPTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.CMP
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "CMP" do
    test "#$nn immediate $C9", %{c: c} do
      c =
        c
        |> setup_computer_for(0xC9)
        |> Computer.load(0x8000, [0xC9, 0x01])
        |> CPU.set(:a, 0xFF)
        |> CMP.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0xFF
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == true
    end

    test "$nnnn absolute $CD", %{c: c} do
      c =
        c
        |> setup_computer_for(0xCD)
        |> Computer.load(0x8000, [0xCD, 0x50, 0x80])
        |> Computer.load(0x8050, [0x97])
        |> CPU.set(:a, 0x12)
        |> CMP.execute()

      assert c.cpu.pc == 0x8003
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == false
    end

    test "$nnnn,X x-indexed absolute $DD", %{c: c} do
      c =
        c
        |> setup_computer_for(0xDD)
        |> Computer.load(0x8000, [0xDD, 0x50, 0x80])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x8055, [0x12])
        |> CPU.set(:a, 0x12)
        |> CMP.execute()

      assert c.cpu.pc == 0x8003
      assert CPU.flag(c, :z) == true
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
    end

    test "$nnnn,Y y-indexed absolute $D9", %{c: c} do
      c =
        c
        |> setup_computer_for(0xD9)
        |> Computer.load(0x8000, [0xD9, 0x50, 0x80])
        |> CPU.set(:y, 0x05)
        |> Computer.load(0x8055, [0x55])
        |> CPU.set(:a, 0x56)
        |> CMP.execute()

      assert c.cpu.pc == 0x8003
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
    end

    test "$nn zero page $C5", %{c: c} do
      c =
        c
        |> setup_computer_for(0xC5)
        |> Computer.load(0x8000, [0xC5, 0x50])
        |> Computer.load(0x0050, [80])
        |> CPU.set(:a, 34)
        |> CMP.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == false
    end

    test "$nn,X x-indexed zero page $D5", %{c: c} do
      c =
        c
        |> setup_computer_for(0xD5)
        |> Computer.load(0x8000, [0xD5, 0x50])
        |> CPU.set(:x, 0x09)
        |> Computer.load(0x0059, [101])
        |> CPU.set(:a, 100)
        |> CMP.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == false
    end

    test "($nn) zero page indirect $D2", %{c: c} do
      c =
        c
        |> setup_computer_for(0xD2)
        |> Computer.load(0x8000, [0xD2, 0x50])
        |> Computer.load(0x0050, [0x28, 0xA2])
        |> Computer.load(0xA228, [100])
        |> CPU.set(:a, 101)
        |> CMP.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
    end

    test "($nn,X) x-indexed zero page indirect $C1", %{c: c} do
      c =
        c
        |> setup_computer_for(0xC1)
        |> Computer.load(0x8000, [0xC1, 0x50])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x0055, [0x28, 0xA2])
        |> Computer.load(0xA228, [0x77])
        |> CPU.set(:a, 0x11)
        |> CMP.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == false
    end

    test "($nn),Y zero page indirect y-indexed $D1", %{c: c} do
      c =
        c
        |> setup_computer_for(0xD1)
        |> Computer.load(0x8000, [0xD1, 0x50])
        |> Computer.load(0x0050, [0x28, 0xA2])
        |> CPU.set(:y, 0x08)
        |> Computer.load(0xA230, [0x77])
        |> CPU.set(:a, 0x8A)
        |> CMP.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
    end
  end
end

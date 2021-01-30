defmodule Ex6502.CPU.Executor.SBCTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.SBC
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "SBC" do
    test "#$nn immediate $E9", %{c: c} do
      c =
        c
        |> setup_computer_for(0xE9)
        |> Computer.load(0x8000, [0xE9, 0xB0])
        |> CPU.set_flag(:c, 1)
        |> CPU.set(:a, 0x50)
        |> SBC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0xA0
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == false
      assert CPU.flag(c, :v) == true
    end

    test "$nnnn absolute $ED", %{c: c} do
      c =
        c
        |> setup_computer_for(0xED)
        |> Computer.load(0x8000, [0xED, 0x50, 0x80])
        |> Computer.load(0x8050, [0x70])
        |> CPU.set_flag(:c, 1)
        |> CPU.set(:a, 0xD0)
        |> SBC.execute()

      assert c.cpu.pc == 0x8003
      assert c.cpu.a == 0x60
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
      assert CPU.flag(c, :v) == true
    end

    test "$nnnn,X x-indexed absolute $FD", %{c: c} do
      c =
        c
        |> setup_computer_for(0xFD)
        |> Computer.load(0x8000, [0xFD, 0x50, 0x80])
        |> CPU.set_flag(:c, 1)
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x8055, [0x12])
        |> CPU.set(:a, 0x19)
        |> SBC.execute()

      assert c.cpu.pc == 0x8003
      assert c.cpu.a == 0x07
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
      assert CPU.flag(c, :v) == false
    end

    test "$nnnn,Y y-indexed absolute $F9", %{c: c} do
      c =
        c
        |> setup_computer_for(0xF9)
        |> Computer.load(0x8000, [0xF9, 0x50, 0x80])
        |> CPU.set_flag(:c, 1)
        |> CPU.set(:y, 0x05)
        |> Computer.load(0x8055, [0x12])
        |> CPU.set(:a, 0x99)
        |> SBC.execute()

      assert c.cpu.pc == 0x8003
      assert c.cpu.a == 0x87
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == true
      assert CPU.flag(c, :v) == false
    end

    test "$nn zero page $E5", %{c: c} do
      c =
        c
        |> setup_computer_for(0xE5)
        |> Computer.load(0x8000, [0xE5, 0x50])
        |> CPU.set_flag(:c, 1)
        |> Computer.load(0x0050, [126])
        |> CPU.set(:a, 127)
        |> SBC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0x01
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
      assert CPU.flag(c, :v) == false
    end

    test "$nn,X x-indexed zero page $F5", %{c: c} do
      c =
        c
        |> setup_computer_for(0xF5)
        |> Computer.load(0x8000, [0xF5, 0x50])
        |> CPU.set_flag(:c, 1)
        |> CPU.set(:x, 0x09)
        |> Computer.load(0x0059, [0x05])
        |> CPU.set(:a, 0x03)
        |> SBC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0xFE
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == false
      assert CPU.flag(c, :v) == false
    end

    test "($nn) zero page indirect $F2", %{c: c} do
      c =
        c
        |> setup_computer_for(0xF2)
        |> Computer.load(0x8000, [0xF2, 0x50])
        |> Computer.load(0x0050, [0x28, 0xA2])
        |> Computer.load(0xA228, [0xAA])
        |> CPU.set_flag(:c, 1)
        |> CPU.set(:a, 0x99)
        |> SBC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0xEF
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == false
      assert CPU.flag(c, :v) == false
    end

    test "($nn,X) x-indexed zero page indirect $E1", %{c: c} do
      c =
        c
        |> setup_computer_for(0xE1)
        |> Computer.load(0x8000, [0xE1, 0x50])
        |> CPU.set(:x, 0x05)
        |> CPU.set_flag(:c, 1)
        |> Computer.load(0x0055, [0x28, 0xA2])
        |> Computer.load(0xA228, [0x77])
        |> CPU.set(:a, 0x11)
        |> SBC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0x9A
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == false
      assert CPU.flag(c, :v) == false
    end

    test "($nn),Y zero page indirect y-indexed $F1", %{c: c} do
      c =
        c
        |> setup_computer_for(0xF1)
        |> Computer.load(0x8000, [0xF1, 0x50])
        |> Computer.load(0x0050, [0x28, 0xA2])
        |> CPU.set_flag(:c, 1)
        |> CPU.set(:y, 0x08)
        |> Computer.load(0xA230, [0x99])
        |> CPU.set(:a, 0x99)
        |> SBC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0x00
      assert CPU.flag(c, :z) == true
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
      assert CPU.flag(c, :v) == false
    end
  end
end

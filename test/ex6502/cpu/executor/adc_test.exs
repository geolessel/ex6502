defmodule Ex6502.CPU.Executor.ADCTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.ADC
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "ADC" do
    test "#$nn immediate $69", %{c: c} do
      c =
        c
        |> setup_computer_for(0x69)
        |> Computer.load(0x8000, [0x69, 0xFF])
        |> CPU.set(:a, 0x01)
        |> ADC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0x00
      assert CPU.flag(c, :z) == true
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
      assert CPU.flag(c, :v) == true
    end

    test "$nnnn absolute $6D", %{c: c} do
      c =
        c
        |> setup_computer_for(0x6D)
        |> Computer.load(0x8000, [0x6D, 0x50, 0x80])
        |> Computer.load(0x8050, [0x12])
        |> CPU.set(:a, 0x97)
        |> ADC.execute()

      assert c.cpu.pc == 0x8003
      assert c.cpu.a == 0xA9
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == false
      assert CPU.flag(c, :v) == true
    end

    test "$nnnn,X x-indexed absolute $7D", %{c: c} do
      c =
        c
        |> setup_computer_for(0x7D)
        |> Computer.load(0x8000, [0x7D, 0x50, 0x80])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x8055, [0x12])
        |> CPU.set(:a, 0x19)
        |> ADC.execute()

      assert c.cpu.pc == 0x8003
      assert c.cpu.a == 0x2B
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == false
      assert CPU.flag(c, :v) == false
    end

    test "$nnnn,Y y-indexed absolute $79", %{c: c} do
      c =
        c
        |> setup_computer_for(0x79)
        |> Computer.load(0x8000, [0x79, 0x50, 0x80])
        |> CPU.set(:y, 0x05)
        |> Computer.load(0x8055, [0x12])
        |> CPU.set(:a, 0x79)
        |> ADC.execute()

      assert c.cpu.pc == 0x8003
      assert c.cpu.a == 0x8B
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == false
      assert CPU.flag(c, :v) == true
    end

    test "$nn zero page $65", %{c: c} do
      c =
        c
        |> setup_computer_for(0x65)
        |> Computer.load(0x8000, [0x65, 0x50])
        |> Computer.load(0x0050, [127])
        |> CPU.set(:a, -127)
        |> ADC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0x00
      assert CPU.flag(c, :z) == true
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == false
      assert CPU.flag(c, :v) == false
    end

    test "$nn,X x-indexed zero page $75", %{c: c} do
      c =
        c
        |> setup_computer_for(0x75)
        |> Computer.load(0x8000, [0x75, 0x50])
        |> CPU.set(:x, 0x09)
        |> Computer.load(0x0059, [0x28])
        |> CPU.set(:a, 0x90)
        |> ADC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0xB8
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == false
      assert CPU.flag(c, :v) == true
    end

    test "($nn) zero page indirect $72", %{c: c} do
      c =
        c
        |> setup_computer_for(0x72)
        |> Computer.load(0x8000, [0x72, 0x50])
        |> Computer.load(0x0050, [0x28, 0xA2])
        |> Computer.load(0xA228, [0x77])
        |> CPU.set(:a, 0x00)
        |> ADC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0x77
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == false
      assert CPU.flag(c, :v) == false
    end

    test "($nn,X) x-indexed zero page indirect $61", %{c: c} do
      c =
        c
        |> setup_computer_for(0x61)
        |> Computer.load(0x8000, [0x61, 0x50])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x0055, [0x28, 0xA2])
        |> Computer.load(0xA228, [0x77])
        |> CPU.set(:a, 0x11)
        |> ADC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0x88
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == false
      assert CPU.flag(c, :v) == true
    end

    test "($nn),Y zero page indirect y-indexed $71", %{c: c} do
      c =
        c
        |> setup_computer_for(0x71)
        |> Computer.load(0x8000, [0x71, 0x50])
        |> Computer.load(0x0050, [0x28, 0xA2])
        |> CPU.set(:y, 0x08)
        |> Computer.load(0xA230, [0x77])
        |> CPU.set(:a, 0x8A)
        |> ADC.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0x01
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
      assert CPU.flag(c, :v) == false
    end
  end
end

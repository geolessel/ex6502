defmodule Ex6502.CPU.Executor.ORATest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.ORA
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "ORA" do
    test "#$nn immediate $09", %{c: c} do
      c =
        c
        |> setup_computer_for(0x09)
        |> Computer.load(0x8000, [0x09, 0b10101010])
        |> CPU.set(:a, 0b00001111)
        |> ORA.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0b10101111
    end

    test "$nnnn absolute $0D", %{c: c} do
      c =
        c
        |> setup_computer_for(0x0D)
        |> Computer.load(0x8000, [0x0D, 0x50, 0x80])
        |> Computer.load(0x8050, [0b10101010])
        |> CPU.set(:a, 0b11110000)
        |> ORA.execute()

      assert c.cpu.pc == 0x8003
      assert c.cpu.a == 0b11111010
    end

    test "$nnnn,X x-indexed absolute $1D", %{c: c} do
      c =
        c
        |> setup_computer_for(0x1D)
        |> Computer.load(0x8000, [0x1D, 0x00, 0x90])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x9005, [0b10101010])
        |> CPU.set(:a, 0b00111100)
        |> ORA.execute()

      assert c.cpu.a == 0b10111110
      assert c.cpu.pc == 0x8003
    end

    test "$nnnn,Y y-indexed absolute $19", %{c: c} do
      c =
        c
        |> setup_computer_for(0x19)
        |> Computer.load(0x8000, [0x19, 0x00, 0x90])
        |> CPU.set(:y, 0x05)
        |> Computer.load(0x9005, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> ORA.execute()

      assert c.cpu.a == 0b11101110
      assert c.cpu.pc == 0x8003
    end

    test "$nn zero page $05", %{c: c} do
      c =
        c
        |> setup_computer_for(0x05)
        |> Computer.load(0x8000, [0x05, 0x90])
        |> Computer.load(0x0090, [0b11111111])
        |> CPU.set(:a, 0b10101010)
        |> ORA.execute()

      assert c.cpu.a == 0b11111111
      assert c.cpu.pc == 0x8002
    end

    test "$nn,X X-indexed zero page $15", %{c: c} do
      c =
        c
        |> setup_computer_for(0x15)
        |> Computer.load(0x8000, [0x55, 0x90])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x0095, [0b10101010])
        |> CPU.set(:a, 0b11111111)
        |> ORA.execute()

      assert c.cpu.a == 0b11111111
      assert c.cpu.pc == 0x8002
    end

    test "($nn) zero page indirect $12", %{c: c} do
      c =
        c
        |> setup_computer_for(0x12)
        |> Computer.load(0x8000, [0x12, 0x90])
        |> Computer.load(0x0090, [0x23, 0x91])
        |> Computer.load(0x9123, [0b00111100])
        |> CPU.set(:a, 0b11110000)
        |> ORA.execute()

      assert c.cpu.a == 0b11111100
      assert c.cpu.pc == 0x8002
    end

    test "($nn,X) x-indexed zero page indirect $01", %{c: c} do
      c =
        c
        |> setup_computer_for(0x01)
        |> Computer.load(0x8000, [0x01, 0x90])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x0095, [0x23, 0x91])
        |> Computer.load(0x9123, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> ORA.execute()

      assert c.cpu.a == 0b11101110
      assert c.cpu.pc == 0x8002
    end

    test "($nn),Y zero page indirect y-indexed $11", %{c: c} do
      c =
        c
        |> setup_computer_for(0x11)
        |> Computer.load(0x8000, [0x11, 0x90])
        |> Computer.load(0x0090, [0x23, 0x91])
        |> CPU.set(:y, 0x80)
        |> Computer.load(0x91A3, [0b00000000])
        |> CPU.set(:a, 0b10101010)
        |> ORA.execute()

      assert c.cpu.a == 0b10101010
      assert c.cpu.pc == 0x8002
    end
  end

  describe "flags" do
    test "n flag set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x09)
        |> Computer.load(0x8000, [0x09, 0b00000000])
        |> CPU.set(:a, 0b10000000)
        |> ORA.execute()

      assert CPU.flag(c, :n) == true
    end

    test "n flag clear", %{c: c} do
      c =
        c
        |> CPU.set_flag(:n, true)
        |> setup_computer_for(0x09)
        |> Computer.load(0x8000, [0x09, 0b01111111])
        |> CPU.set(:a, 0b01111111)
        |> ORA.execute()

      assert CPU.flag(c, :n) == false
    end

    test "z flag set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x09)
        |> Computer.load(0x8000, [0x09, 0b00000000])
        |> CPU.set(:a, 0b00000000)
        |> ORA.execute()

      assert CPU.flag(c, :z) == true
    end

    test "z flag clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0x09)
        |> Computer.load(0x8000, [0x09, 0b00000001])
        |> CPU.set(:a, 0b00000000)
        |> ORA.execute()

      assert CPU.flag(c, :z) == false
    end
  end
end

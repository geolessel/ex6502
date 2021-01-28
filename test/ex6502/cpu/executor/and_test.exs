defmodule Ex6502.CPU.Executor.ANDTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.AND
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "AND" do
    test "#$nn immediate $29", %{c: c} do
      c =
        c
        |> setup_computer_for(0x29)
        |> Computer.load(0x8000, [0x29, 0b11110000])
        |> CPU.set(:a, 0b00111100)
        |> AND.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0b00110000
    end

    test "$nnnn Absolute $2D", %{c: c} do
      c =
        c
        |> setup_computer_for(0x2D)
        |> Computer.load(0x8000, [0x2D, 0x00, 0x90])
        |> Computer.load(0x9000, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> AND.execute()

      assert c.cpu.a == 0b10001000
      assert c.cpu.pc == 0x8003
    end

    test "$nnnn,X x-indexed absolute $3D", %{c: c} do
      c =
        c
        |> setup_computer_for(0x3D)
        |> Computer.load(0x8000, [0x3D, 0x00, 0x90])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x9005, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> AND.execute()

      assert c.cpu.a == 0b10001000
      assert c.cpu.pc == 0x8003
    end

    test "$nnnn,Y y-indexed absolute $39", %{c: c} do
      c =
        c
        |> setup_computer_for(0x39)
        |> Computer.load(0x8000, [0x39, 0x00, 0x90])
        |> CPU.set(:y, 0x05)
        |> Computer.load(0x9005, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> AND.execute()

      assert c.cpu.a == 0b10001000
      assert c.cpu.pc == 0x8003
    end

    test "$nn zero page $25", %{c: c} do
      c =
        c
        |> setup_computer_for(0x25)
        |> Computer.load(0x8000, [0x25, 0x90])
        |> Computer.load(0x0090, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> AND.execute()

      assert c.cpu.a == 0b10001000
      assert c.cpu.pc == 0x8002
    end

    test "$nn,X X-indexed zero page $35", %{c: c} do
      c =
        c
        |> setup_computer_for(0x35)
        |> Computer.load(0x8000, [0x35, 0x90])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x0095, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> AND.execute()

      assert c.cpu.a == 0b10001000
      assert c.cpu.pc == 0x8002
    end

    test "$(nn) zero page indirect $32", %{c: c} do
      c =
        c
        |> setup_computer_for(0x32)
        |> Computer.load(0x8000, [0x32, 0x90])
        |> Computer.load(0x0090, [0x23, 0x91])
        |> Computer.load(0x9123, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> AND.execute()

      assert c.cpu.a == 0b10001000
      assert c.cpu.pc == 0x8002
    end

    test "$(nn,X) x-indexed zero page indirect $21", %{c: c} do
      c =
        c
        |> setup_computer_for(0x21)
        |> Computer.load(0x8000, [0x21, 0x90])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x0095, [0x23, 0x91])
        |> Computer.load(0x9123, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> AND.execute()

      assert c.cpu.a == 0b10001000
      assert c.cpu.pc == 0x8002
    end

    test "$(nn),Y zero page indirect y-indexed $31", %{c: c} do
      c =
        c
        |> setup_computer_for(0x31)
        |> Computer.load(0x8000, [0x31, 0x90])
        |> Computer.load(0x0090, [0x23, 0x91])
        |> CPU.set(:y, 0x80)
        |> Computer.load(0x91A3, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> AND.execute()

      assert c.cpu.a == 0b10001000
      assert c.cpu.pc == 0x8002
    end
  end

  describe "flags" do
    test "n flag set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x29)
        |> Computer.load(0x8000, [0x29, 0b11111111])
        |> CPU.set(:a, 0b10000000)
        |> AND.execute()

      assert CPU.flag(c, :n) == true
    end

    test "n flag clear", %{c: c} do
      c =
        c
        |> CPU.set_flag(:n, true)
        |> setup_computer_for(0x29)
        |> Computer.load(0x8000, [0x29, 0b11111111])
        |> CPU.set(:a, 0b01111111)
        |> AND.execute()

      assert CPU.flag(c, :n) == false
    end

    test "z flag set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x29)
        |> Computer.load(0x8000, [0x29, 0b11111111])
        |> CPU.set(:a, 0b00000000)
        |> AND.execute()

      assert CPU.flag(c, :z) == true
    end

    test "z flag clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0x29)
        |> Computer.load(0x8000, [0x29, 0b11111111])
        |> CPU.set(:a, 0b10101010)
        |> AND.execute()

      assert CPU.flag(c, :z) == false
    end
  end
end

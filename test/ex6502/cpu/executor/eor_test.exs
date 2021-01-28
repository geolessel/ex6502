defmodule Ex6502.CPU.Executor.EORTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.EOR
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "EOR" do
    test "#$nn immediate $49", %{c: c} do
      c =
        c
        |> setup_computer_for(0x49)
        |> Computer.load(0x8000, [0x49, 0b10101010])
        |> CPU.set(:a, 0b00001111)
        |> EOR.execute()

      assert c.cpu.pc == 0x8002
      assert c.cpu.a == 0b10100101
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
    end

    test "$nnnn absolute $4D", %{c: c} do
      c =
        c
        |> setup_computer_for(0x4D)
        |> Computer.load(0x8000, [0x4D, 0x50, 0x80])
        |> Computer.load(0x8050, [0b10101010])
        |> CPU.set(:a, 0b11110000)
        |> EOR.execute()

      assert c.cpu.pc == 0x8003
      assert c.cpu.a == 0b01011010
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
    end

    test "$nnnn,X x-indexed absolute $5D", %{c: c} do
      c =
        c
        |> setup_computer_for(0x5D)
        |> Computer.load(0x8000, [0x5D, 0x00, 0x90])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x9005, [0b10101010])
        |> CPU.set(:a, 0b00111100)
        |> EOR.execute()

      assert c.cpu.a == 0b10010110
      assert c.cpu.pc == 0x8003
    end

    test "$nnnn,Y y-indexed absolute $59", %{c: c} do
      c =
        c
        |> setup_computer_for(0x59)
        |> Computer.load(0x8000, [0x59, 0x00, 0x90])
        |> CPU.set(:y, 0x05)
        |> Computer.load(0x9005, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> EOR.execute()

      assert c.cpu.a == 0b01100110
      assert c.cpu.pc == 0x8003
    end

    test "$nn zero page $45", %{c: c} do
      c =
        c
        |> setup_computer_for(0x45)
        |> Computer.load(0x8000, [0x45, 0x90])
        |> Computer.load(0x0090, [0b11111111])
        |> CPU.set(:a, 0b10101010)
        |> EOR.execute()

      assert c.cpu.a == 0b01010101
      assert c.cpu.pc == 0x8002
    end

    test "$nn,X X-indexed zero page $55", %{c: c} do
      c =
        c
        |> setup_computer_for(0x55)
        |> Computer.load(0x8000, [0x55, 0x90])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x0095, [0b10101010])
        |> CPU.set(:a, 0b11111111)
        |> EOR.execute()

      assert c.cpu.a == 0b01010101
      assert c.cpu.pc == 0x8002
    end

    test "($nn) zero page indirect $52", %{c: c} do
      c =
        c
        |> setup_computer_for(0x52)
        |> Computer.load(0x8000, [0x52, 0x90])
        |> Computer.load(0x0090, [0x23, 0x91])
        |> Computer.load(0x9123, [0b00111100])
        |> CPU.set(:a, 0b11110000)
        |> EOR.execute()

      assert c.cpu.a == 0b11001100
      assert c.cpu.pc == 0x8002
    end

    test "($nn,X) x-indexed zero page indirect $41", %{c: c} do
      c =
        c
        |> setup_computer_for(0x41)
        |> Computer.load(0x8000, [0x41, 0x90])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x0095, [0x23, 0x91])
        |> Computer.load(0x9123, [0b11001100])
        |> CPU.set(:a, 0b10101010)
        |> EOR.execute()

      assert c.cpu.a == 0b01100110
      assert c.cpu.pc == 0x8002
    end

    test "($nn),Y zero page indirect y-indexed $51", %{c: c} do
      c =
        c
        |> setup_computer_for(0x51)
        |> Computer.load(0x8000, [0x51, 0x90])
        |> Computer.load(0x0090, [0x23, 0x91])
        |> CPU.set(:y, 0x80)
        |> Computer.load(0x91A3, [0b00000000])
        |> CPU.set(:a, 0b10101010)
        |> EOR.execute()

      assert c.cpu.a == 0b10101010
      assert c.cpu.pc == 0x8002
    end
  end

  describe "flags" do
    test "n flag set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x49)
        |> Computer.load(0x8000, [0x49, 0b01010101])
        |> CPU.set(:a, 0b10000000)
        |> EOR.execute()

      assert CPU.flag(c, :n) == true
    end

    test "n flag clear", %{c: c} do
      c =
        c
        |> CPU.set_flag(:n, true)
        |> setup_computer_for(0x49)
        |> Computer.load(0x8000, [0x49, 0b11111111])
        |> CPU.set(:a, 0b10000000)
        |> EOR.execute()

      assert CPU.flag(c, :n) == false
    end

    test "z flag set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x49)
        |> Computer.load(0x8000, [0x49, 0b11111111])
        |> CPU.set(:a, 0b11111111)
        |> EOR.execute()

      assert CPU.flag(c, :z) == true
    end

    test "z flag clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0x49)
        |> Computer.load(0x8000, [0x49, 0b11111111])
        |> CPU.set(:a, 0b10101010)
        |> EOR.execute()

      assert CPU.flag(c, :z) == false
    end
  end
end

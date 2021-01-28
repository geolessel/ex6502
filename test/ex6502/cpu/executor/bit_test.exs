defmodule Ex6502.CPU.Executor.BITTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.BIT
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "BIT" do
    test "#$nn immediate $89", %{c: c} do
      c =
        c
        |> setup_computer_for(0x89)
        |> Computer.load(0x8000, [0x89, 0b11110000])
        |> CPU.set(:a, 0b11000000)
        |> BIT.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :v) == true
      assert CPU.flag(c, :z) == false
    end

    test "#nnnn absolute $2c", %{c: c} do
      c =
        c
        |> setup_computer_for(0x2C)
        |> Computer.load(0x8000, [0x2C, 0x50, 0x80])
        |> Computer.load(0x8050, [0b01000000])
        |> CPU.set(:a, 0b11001111)
        |> BIT.execute()

      assert c.cpu.pc == 0x8003
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :v) == true
      assert CPU.flag(c, :z) == false
    end

    test "#nnnn x-indexed absolute $3c", %{c: c} do
      c =
        c
        |> setup_computer_for(0x3C)
        |> Computer.load(0x8000, [0x3C, 0x50, 0x80])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x8055, [0b10000000])
        |> CPU.set(:a, 0b11001111)
        |> BIT.execute()

      assert c.cpu.pc == 0x8003
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :v) == false
      assert CPU.flag(c, :z) == false
    end

    test "#nn zero page $24", %{c: c} do
      c =
        c
        |> setup_computer_for(0x24)
        |> Computer.load(0x8000, [0x24, 0x50])
        |> Computer.load(0x0050, [0b00000000])
        |> CPU.set(:a, 0b11111111)
        |> BIT.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :v) == false
      assert CPU.flag(c, :z) == true
    end

    test "#nn,X x-indexed zero page $34", %{c: c} do
      c =
        c
        |> setup_computer_for(0x34)
        |> Computer.load(0x8000, [0x34, 0x50])
        |> CPU.set(:x, 0x05)
        |> Computer.load(0x0055, [0b11111111])
        |> CPU.set(:a, 0b01111111)
        |> BIT.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :v) == true
      assert CPU.flag(c, :z) == false
    end
  end
end

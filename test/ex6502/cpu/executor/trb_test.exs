defmodule Ex6502.CPU.Executor.TRBTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.TRB
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "TRB" do
    test "#nnnn absolute $1C", %{c: c} do
      c =
        c
        |> setup_computer_for(0x1C)
        |> Computer.load(0x8000, [0x1C, 0x50, 0x80])
        |> Computer.load(0x8050, [0b01010101])
        |> CPU.set(:a, 0b11000011)
        |> TRB.execute()

      assert c.cpu.pc == 0x8003
      assert Memory.get(c.memory, 0x8050) == 0b00010100
      assert CPU.flag(c, :z) == false
    end

    test "#nn zero page $14", %{c: c} do
      c =
        c
        |> setup_computer_for(0x14)
        |> Computer.load(0x8000, [0x14, 0x50])
        |> Computer.load(0x0050, [0b11111111])
        |> CPU.set(:a, 0b11000011)
        |> TRB.execute()

      assert c.cpu.pc == 0x8002
      assert Memory.get(c.memory, 0x0050) == 0b00111100
      assert CPU.flag(c, :z) == false
    end
  end
end

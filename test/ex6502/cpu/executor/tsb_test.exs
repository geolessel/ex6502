defmodule Ex6502.CPU.Executor.TSBTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.TSB
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "TSB" do
    test "#nnnn absolute $0C", %{c: c} do
      c =
        c
        |> setup_computer_for(0x0C)
        |> Computer.load(0x8000, [0x0C, 0x50, 0x80])
        |> Computer.load(0x8050, [0b01010101])
        |> CPU.set(:a, 0b11000011)
        |> TSB.execute()

      assert c.cpu.pc == 0x8003
      assert Memory.get(c.memory, 0x8050) == 0b11010111
      assert CPU.flag(c, :z) == false
    end

    test "#nn zero page $04", %{c: c} do
      c =
        c
        |> setup_computer_for(0x04)
        |> Computer.load(0x8000, [0x04, 0x50])
        |> Computer.load(0x0050, [0b00111100])
        |> CPU.set(:a, 0b11000011)
        |> TSB.execute()

      assert c.cpu.pc == 0x8002
      assert Memory.get(c.memory, 0x0050) == 0b11111111
      assert CPU.flag(c, :z) == false
    end
  end
end

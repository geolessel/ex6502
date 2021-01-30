defmodule Ex6502.CPU.Executor.DEXTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.DEX
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "DEX" do
    test "implied $CA", %{c: c} do
      c =
        c
        |> setup_computer_for(0xCA)
        |> Computer.load(0x8000, [0xCA])
        |> CPU.set(:x, 0x00)
        |> DEX.execute()

      assert c.cpu.pc == 0x8001
      assert c.cpu.x == 0xFF
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
    end
  end
end

defmodule Ex6502.CPU.Executor.INYTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.INY
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "INY" do
    test "implied $C8", %{c: c} do
      c =
        c
        |> setup_computer_for(0xC8)
        |> Computer.load(0x8000, [0xC8])
        |> CPU.set(:y, 0xFF)
        |> INY.execute()

      assert c.cpu.pc == 0x8001
      assert c.cpu.y == 0x00
      assert CPU.flag(c, :z) == true
      assert CPU.flag(c, :n) == false
    end
  end
end

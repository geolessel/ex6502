defmodule Ex6502.CPU.Executor.INXTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.INX
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "INX" do
    test "implied $E8", %{c: c} do
      c =
        c
        |> setup_computer_for(0xE8)
        |> Computer.load(0x8000, [0xE8])
        |> CPU.set(:x, 0xFF)
        |> INX.execute()

      assert c.cpu.pc == 0x8001
      assert c.cpu.x == 0x00
      assert CPU.flag(c, :z) == true
      assert CPU.flag(c, :n) == false
    end
  end
end

defmodule Ex6502.CPU.Executor.DEYTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.DEY
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "DEY" do
    test "implied $88", %{c: c} do
      c =
        c
        |> setup_computer_for(0x88)
        |> Computer.load(0x8000, [0x88])
        |> CPU.set(:y, 0x00)
        |> DEY.execute()

      assert c.cpu.pc == 0x8001
      assert c.cpu.y == 0xFF
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
    end
  end
end

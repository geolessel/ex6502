defmodule Ex6502.CPU.Executor.BCSTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.BCS
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "BCS" do
    test "relative $B0 carry set forward", %{c: c} do
      c =
        c
        |> setup_computer_for(0xB0)
        |> CPU.set_flag(:c, true)
        |> Computer.load(0x8000, [0xB0, 0x7F])
        |> BCS.execute()

      # should move ahead 0x7f + 1 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 0x01 + 0x7F
    end

    test "relative $B0 carry set backwards", %{c: c} do
      c =
        c
        |> setup_computer_for(0xB0)
        |> CPU.set_flag(:c, true)
        |> Computer.load(0x8000, [0xB0, 0x80, 0xFF])
        |> BCS.execute()

      # should move -128 + 1 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 1 - 128
    end

    test "relative $B0 carry clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0xB0)
        |> CPU.set_flag(:c, false)
        |> Computer.load(0x8000, [0xB0, 0x80])
        |> BCS.execute()

      assert c.cpu.pc == 0x8002
    end
  end
end

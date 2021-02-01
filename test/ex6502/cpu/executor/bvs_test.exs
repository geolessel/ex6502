defmodule Ex6502.CPU.Executor.BVSTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.BVS
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "BVS" do
    test "relative $70 overflow set forward", %{c: c} do
      c =
        c
        |> setup_computer_for(0x70)
        |> CPU.set_flag(:v, true)
        |> Computer.load(0x8000, [0x70, 0x7F])
        |> BVS.execute()

      # should move ahead 0x7f + 1 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 0x01 + 0x7F
    end

    test "relative $70 overflow set backwards", %{c: c} do
      c =
        c
        |> setup_computer_for(0x70)
        |> CPU.set_flag(:v, true)
        |> Computer.load(0x8000, [0x70, 0x80])
        |> BVS.execute()

      # should move -128 + 1 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 1 - 128
    end

    test "relative $70 overflow clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0x70)
        |> CPU.set_flag(:v, false)
        |> Computer.load(0x8000, [0x70, 0x80])
        |> BVS.execute()

      assert c.cpu.pc == 0x8002
    end
  end
end

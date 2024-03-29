defmodule Ex6502.CPU.Executor.BVCTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.BVC
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "BVC" do
    test "relative $50 overflow clear forward", %{c: c} do
      c =
        c
        |> setup_computer_for(0x50)
        |> CPU.set_flag(:v, false)
        |> Computer.load(0x8000, [0x50, 0x7F])
        |> BVC.execute()

      # should move ahead 0x7f + 1 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 0x01 + 0x7F
    end

    test "relative $50 overflow clear backwards", %{c: c} do
      c =
        c
        |> setup_computer_for(0x50)
        |> CPU.set_flag(:v, false)
        |> Computer.load(0x8000, [0x50, 0x80])
        |> BVC.execute()

      # should move -128 + 1 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 1 - 128
    end

    test "relative $50 overflow set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x50)
        |> CPU.set_flag(:v, true)
        |> Computer.load(0x8000, [0x50, 0x80])
        |> BVC.execute()

      assert c.cpu.pc == 0x8002
    end
  end
end

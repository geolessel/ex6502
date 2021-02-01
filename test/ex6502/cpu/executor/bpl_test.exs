defmodule Ex6502.CPU.Executor.BPLTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.BPL
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "BPL" do
    test "relative $10 negative clear forward", %{c: c} do
      c =
        c
        |> setup_computer_for(0x10)
        |> CPU.set_flag(:n, false)
        |> Computer.load(0x8000, [0x10, 0x7F])
        |> BPL.execute()

      # should move ahead 0x7f + 1 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 0x01 + 0x7F
    end

    test "relative $10 negative clear backwards", %{c: c} do
      c =
        c
        |> setup_computer_for(0x10)
        |> CPU.set_flag(:n, false)
        |> Computer.load(0x8000, [0x10, 0x80])
        |> BPL.execute()

      # should move -128 + 1 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 1 - 128
    end

    test "relative $10 negative set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x10)
        |> CPU.set_flag(:n, true)
        |> Computer.load(0x8000, [0x10, 0x80])
        |> BPL.execute()

      assert c.cpu.pc == 0x8002
    end
  end
end

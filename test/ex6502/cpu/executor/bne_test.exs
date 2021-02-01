defmodule Ex6502.CPU.Executor.BNETest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.BNE
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "BNE" do
    test "relative $D0 zero clear forward", %{c: c} do
      c =
        c
        |> setup_computer_for(0xD0)
        |> CPU.set_flag(:z, false)
        |> Computer.load(0x8000, [0xD0, 0x7F, 0xFF])
        |> BNE.execute()

      # should move ahead 0x7f + 2 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 0x02 + 0x7F
    end

    test "relative $D0 zero clear backwards", %{c: c} do
      c =
        c
        |> setup_computer_for(0xD0)
        |> CPU.set_flag(:z, false)
        |> Computer.load(0x8000, [0xD0, 0x80, 0xFF])
        |> BNE.execute()

      # should move -128 + 2 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 2 - 128
    end

    test "relative $D0 zero set", %{c: c} do
      c =
        c
        |> setup_computer_for(0xD0)
        |> CPU.set_flag(:z, true)
        |> Computer.load(0x8000, [0xD0, 0x80, 0xFF])
        |> BNE.execute()

      assert c.cpu.pc == 0x8003
    end
  end
end

defmodule Ex6502.CPU.Executor.BRATest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.BRA
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "BRA" do
    test "relative $80 forward", %{c: c} do
      c =
        c
        |> setup_computer_for(0x80)
        |> Computer.load(0x8000, [0x80, 0x7F, 0x00])
        |> BRA.execute()

      # should move ahead 0x7f + 2 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 0x02 + 0x7F
    end

    test "relative $80 backwards", %{c: c} do
      c =
        c
        |> setup_computer_for(0x80)
        |> Computer.load(0x8000, [0x80, 0x80, 0x00])
        |> BRA.execute()

      # should move -128 + 2 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 2 - 128
    end
  end
end

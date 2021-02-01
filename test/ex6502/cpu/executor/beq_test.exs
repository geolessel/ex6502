defmodule Ex6502.CPU.Executor.BEQTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.BEQ
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "BEQ" do
    test "relative $F0 zero set forward", %{c: c} do
      c =
        c
        |> setup_computer_for(0xF0)
        |> CPU.set_flag(:z, true)
        |> Computer.load(0x8000, [0xF0, 0x7F])
        |> BEQ.execute()

      # should move ahead 0x7f + 1 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 0x01 + 0x7F
    end

    test "relative $F0 zero set backwards", %{c: c} do
      c =
        c
        |> setup_computer_for(0xF0)
        |> CPU.set_flag(:z, true)
        |> Computer.load(0x8000, [0xF0, 0x80])
        |> BEQ.execute()

      # should move -128 + 1 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 1 - 128
    end

    test "relative $F0 zero clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0xF0)
        |> CPU.set_flag(:z, false)
        |> Computer.load(0x8000, [0xF0, 0x80])
        |> BEQ.execute()

      assert c.cpu.pc == 0x8002
    end
  end
end

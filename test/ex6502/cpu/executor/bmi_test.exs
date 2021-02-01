defmodule Ex6502.CPU.Executor.BMITest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.BMI
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "BMI" do
    test "relative $30 negative set forward", %{c: c} do
      c =
        c
        |> setup_computer_for(0x30)
        |> CPU.set_flag(:n, true)
        |> Computer.load(0x8000, [0x30, 0x7F, 0xFF])
        |> BMI.execute()

      # should move ahead 0x7f + 2 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 0x02 + 0x7F
    end

    test "relative $30 negative set backwards", %{c: c} do
      c =
        c
        |> setup_computer_for(0x30)
        |> CPU.set_flag(:n, true)
        |> Computer.load(0x8000, [0x30, 0x80, 0xFF])
        |> BMI.execute()

      # should move -128 + 2 (for address bytes of instruction)
      assert c.cpu.pc == 0x8001 + 2 - 128
    end

    test "relative $30 negative clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0x30)
        |> CPU.set_flag(:n, false)
        |> Computer.load(0x8000, [0x30, 0x80, 0xFF])
        |> BMI.execute()

      assert c.cpu.pc == 0x8003
    end
  end
end

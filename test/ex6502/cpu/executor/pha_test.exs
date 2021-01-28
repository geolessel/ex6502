defmodule Ex6502.CPU.Executor.PHATest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.{Computer, CPU, Memory}
  alias Ex6502.CPU.Executor.PHA

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "PHA" do
    test "$48", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x48])
        |> setup_computer_for(0x48)
        |> CPU.set(:a, 0x99)
        |> PHA.execute()

      assert c.cpu.sp == 0xFE
      assert c.cpu.pc == 0x8001
      assert Memory.get(c.memory, 0x01FF) == 0x99
    end
  end
end

defmodule Ex6502.CPU.Executor.PHYTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.{Computer, CPU, Memory}
  alias Ex6502.CPU.Executor.PHY

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "PHY" do
    test "$5a", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x5A])
        |> setup_computer_for(0x5A)
        |> CPU.set(:y, 0x99)
        |> PHY.execute()

      assert c.cpu.sp == 0xFE
      assert c.cpu.pc == 0x8001
      assert Memory.get(c.memory, 0x01FF) == 0x99
    end
  end
end

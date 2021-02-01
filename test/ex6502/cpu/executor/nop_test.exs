defmodule Ex6502.CPU.Executor.NOPTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.NOP
  alias Ex6502.{Computer, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "NOP" do
    test "$EA", %{c: original_c} do
      c =
        original_c
        |> setup_computer_for(0xEA)
        |> Computer.load(0x8000, [0xEA])
        |> NOP.execute()

      assert c.cpu.pc == 0x8001
    end
  end
end

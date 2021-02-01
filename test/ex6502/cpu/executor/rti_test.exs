defmodule Ex6502.CPU.Executor.RTITest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.RTI
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "RTI" do
    test "$nnnn absolute $40", %{c: c} do
      c =
        c
        |> setup_computer_for(0x40)
        |> Computer.load(0x8000, [0x40])
        |> Computer.load(0x01FD, [0b11001111, 0x12, 0x91])
        |> CPU.set(:sp, 0xFC)
        |> RTI.execute()

      assert c.cpu.pc == 0x9112
      assert c.cpu.p == 0b11001111
    end
  end
end

defmodule Ex6502.CPU.Executor.RTSTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.RTS
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "RTS" do
    test "$nnnn absolute $60", %{c: c} do
      c =
        c
        |> setup_computer_for(0x60)
        |> Computer.load(0x8000, [0x60])
        |> Computer.load(0x01FD, [0x12, 0x91])
        |> CPU.set(:sp, 0xFC)
        |> RTS.execute()

      assert c.cpu.pc == 0x9113
    end
  end
end

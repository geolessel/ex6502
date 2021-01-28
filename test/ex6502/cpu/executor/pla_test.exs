defmodule Ex6502.CPU.Executor.PLATest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.{Computer, CPU, Memory}
  alias Ex6502.CPU.Executor.PLA

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "PLA" do
    test "$68", %{c: c} do
      c =
        c
        |> setup_computer_for(0x68)
        |> Computer.load(0x8000, [0x68])
        |> Computer.load(0x01FF, [0x99])
        |> CPU.set(:sp, 0xFE)
        |> CPU.set(:a, 0x00)
        |> PLA.execute()

      assert c.cpu.sp == 0xFF
      assert c.cpu.pc == 0x8001
      assert c.cpu.a == 0x99
    end
  end
end

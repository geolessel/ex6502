defmodule Ex6502.CPU.Executor.JMPTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.JMP
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "JMP" do
    test "$nnnn absolute $4C", %{c: c} do
      c =
        c
        |> setup_computer_for(0x4C)
        |> Computer.load(0x8000, [0x4C, 0x34, 0x12])
        |> JMP.execute()

      assert c.cpu.pc == 0x1234
    end

    test "($nnnn) indirect $6C", %{c: c} do
      c =
        c
        |> setup_computer_for(0x6C)
        |> Computer.load(0x8000, [0x6C, 0x34, 0x12])
        |> Computer.load(0x1234, [0x23, 0x45])
        |> JMP.execute()

      assert c.cpu.pc == 0x4523
    end

    test "($nnnn,X) x-indexed indirect $7C", %{c: c} do
      c =
        c
        |> setup_computer_for(0x7C)
        |> Computer.load(0x8000, [0x7C, 0x34, 0x12])
        |> Computer.load(0x1239, [0x23, 0x45])
        |> CPU.set(:x, 0x05)
        |> JMP.execute()

      assert c.cpu.pc == 0x4523
    end
  end
end

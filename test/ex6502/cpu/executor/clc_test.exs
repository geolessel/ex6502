defmodule Ex6502.CPU.Executor.CLCTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.CLC
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "CLC" do
    test "$18", %{c: c} do
      c =
        c
        |> setup_computer_for(0x18)
        |> Computer.load(0x8000, [0x18, 0x7F, 0xFF])
        |> CPU.set_flag(:c, true)
        |> CLC.execute()

      assert CPU.flag(c, :c) == false
    end
  end
end

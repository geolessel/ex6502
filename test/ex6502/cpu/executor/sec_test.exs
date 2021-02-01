defmodule Ex6502.CPU.Executor.SECTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.SEC
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "SEC" do
    test "$38", %{c: c} do
      c =
        c
        |> setup_computer_for(0x38)
        |> Computer.load(0x8000, [0x38])
        |> CPU.set_flag(:c, false)
        |> SEC.execute()

      assert CPU.flag(c, :c) == true
    end
  end
end

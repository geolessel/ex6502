defmodule Ex6502.CPU.Executor.SEITest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.SEI
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "SEI" do
    test "$78", %{c: c} do
      c =
        c
        |> setup_computer_for(0x78)
        |> Computer.load(0x8000, [0x78])
        |> CPU.set_flag(:i, false)
        |> SEI.execute()

      assert CPU.flag(c, :i) == true
    end
  end
end

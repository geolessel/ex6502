defmodule Ex6502.CPU.Executor.CLDTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.CLD
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "CLD" do
    test "$D8", %{c: c} do
      c =
        c
        |> setup_computer_for(0xD8)
        |> Computer.load(0x8000, [0xD8])
        |> CPU.set_flag(:d, true)
        |> CLD.execute()

      assert CPU.flag(c, :d) == false
    end
  end
end

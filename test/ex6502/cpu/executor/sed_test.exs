defmodule Ex6502.CPU.Executor.SEDTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.SED
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "SED" do
    test "$F8", %{c: c} do
      c =
        c
        |> setup_computer_for(0xF8)
        |> Computer.load(0x8000, [0xF8])
        |> CPU.set_flag(:d, false)
        |> SED.execute()

      assert CPU.flag(c, :d) == true
    end
  end
end

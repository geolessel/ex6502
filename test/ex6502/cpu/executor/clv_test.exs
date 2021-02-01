defmodule Ex6502.CPU.Executor.CLVTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.CLV
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "CLV" do
    test "$B8", %{c: c} do
      c =
        c
        |> setup_computer_for(0xB8)
        |> Computer.load(0x8000, [0xB8])
        |> CPU.set_flag(:v, true)
        |> CLV.execute()

      assert CPU.flag(c, :v) == false
    end
  end
end

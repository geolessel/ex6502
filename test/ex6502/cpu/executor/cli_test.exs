defmodule Ex6502.CPU.Executor.CLITest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.CLI
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "CLI" do
    test "$58", %{c: c} do
      c =
        c
        |> setup_computer_for(0x58)
        |> Computer.load(0x8000, [0xD8])
        |> CPU.set_flag(:i, true)
        |> CLI.execute()

      assert CPU.flag(c, :i) == false
    end
  end
end

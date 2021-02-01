defmodule Ex6502.CPU.Executor.JSRTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.JSR
  alias Ex6502.{Computer, Memory}
  alias Ex6502.CPU.Stack

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "JSR" do
    test "$nnnn absolute $20", %{c: c} do
      c =
        c
        |> setup_computer_for(0x20)
        |> Computer.load(0x8000, [0x20, 0x34, 0x12])
        |> JSR.execute()

      assert c.cpu.pc == 0x1234
      assert Memory.get(c.memory, Stack.resolve_address(c.cpu.sp + 1)) == 0x02
      assert Memory.get(c.memory, Stack.resolve_address(c.cpu.sp + 2)) == 0x80
    end
  end
end

defmodule Ex6502.CPU.StackTest do
  use ExUnit.Case, async: true

  alias Ex6502.{Computer, Memory}
  alias Ex6502.CPU.Stack

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  test "push/2 pushes a value at the current pointer", %{c: c} do
    assert c.cpu.sp == 0xFF
    c = Stack.push(c, 0x99)
    assert Memory.get(c.memory, 0x1FF) == 0x99
  end

  test "push/2 decrements the stack pointer", %{c: c} do
    assert c.cpu.sp == 0xFF
    c = Stack.push(c, 0x99)
    assert c.cpu.sp == 0xFE
  end
end

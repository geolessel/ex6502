defmodule Ex6502.CPU.Executor.BRKTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.BRK
  alias Ex6502.{Computer, CPU, Memory}
  alias Ex6502.CPU.Stack

  use Bitwise

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  test "BRK", %{c: c} do
    assert c.cpu.sp == 0xFF

    c =
      c
      |> setup_computer_for(0x00)
      |> CPU.set_flag(:n, true)
      |> CPU.set_flag(:v, true)
      |> CPU.set_flag(:c, true)
      |> Computer.load(0x8000, [0x00])

    previous_p = c.cpu.p

    c = BRK.execute(c)

    assert c.cpu.pc == 0xFFFE
    assert c.cpu.sp == 0xFC
    # processor status with B flag set
    assert Memory.get(c.memory, Stack.resolve_address(c.cpu.sp + 1)) == (previous_p ||| 0x10)
    # low byte of previous pc
    assert Memory.get(c.memory, Stack.resolve_address(c.cpu.sp + 2)) == 0x01
    # high byte of previous pc
    assert Memory.get(c.memory, Stack.resolve_address(c.cpu.sp + 3)) == 0x80
  end
end

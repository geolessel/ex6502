defmodule Ex6502.CPUTest do
  use ExUnit.Case, async: true

  alias Ex6502.{Computer, CPU}

  test "step_pc increments pc" do
    cpu =
      %CPU{pc: 0}
      |> CPU.step_pc()

    assert cpu.pc == 1

    cpu = CPU.step_pc(cpu, 2)
    assert cpu.pc == 3
  end

  test "set/2 sets a register from the data_bus" do
    c =
      %Computer{data_bus: 10}
      |> CPU.set(:a)

    assert c.cpu.a == 10
  end

  test "set/3 sets a register from arguments" do
    c =
      %Computer{}
      |> CPU.set(:a, 10)

    assert c.cpu.a == 10
  end

  test "flag/2 returns a boolean indicating status" do
    c = %Computer{cpu: %{p: 0b10101010}}

    assert CPU.flag(c, :c) == false
    assert CPU.flag(c, :z) == true
    assert CPU.flag(c, :i) == false
    assert CPU.flag(c, :d) == true
    assert CPU.flag(c, :b) == false
    assert CPU.flag(c, :v) == false
    assert CPU.flag(c, :n) == true
  end

  test "set_flags/3 sets flags" do
    c =
      %Computer{cpu: %CPU{a: 0x00}}
      |> CPU.set_flags([:z, :n], :a)

    assert CPU.flag(c, :z) == true
    assert CPU.flag(c, :n) == false

    c =
      %Computer{cpu: %CPU{a: 0x80}}
      |> CPU.set_flags([:z, :n], :a)

    assert CPU.flag(c, :z) == false
    assert CPU.flag(c, :n) == true
  end
end

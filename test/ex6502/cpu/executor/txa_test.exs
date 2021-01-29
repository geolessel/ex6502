defmodule Ex6502.CPU.Executor.TXATest do
  use ExUnit.Case, async: true

  alias Ex6502.CPU.Executor.TXA
  alias Ex6502.{Computer, CPU}

  describe "TXA" do
    test "$8a" do
      c =
        %Computer{cpu: %CPU{x: 0x99, a: 0x88, pc: 0}, data_bus: 0x8A}
        |> TXA.execute()

      assert c.cpu.a == 0x99
      assert c.cpu.pc == 1
    end
  end

  describe "flags" do
    test "z flag set" do
      c = %Computer{cpu: %CPU{x: 0x00, a: 0x88, pc: 0}, data_bus: 0x8A}
      assert CPU.flag(c, :z) == false

      c = TXA.execute(c)
      assert CPU.flag(c, :z) == true
    end

    test "z flag clear" do
      c = %Computer{cpu: %CPU{x: 0x99, a: 0x88, pc: 0, p: 0b00000010}, data_bus: 0x8A}
      assert CPU.flag(c, :z) == true

      c = TXA.execute(c)
      assert CPU.flag(c, :z) == false
    end

    test "n flag set" do
      c = %Computer{cpu: %CPU{x: 0x90, a: 0x88, pc: 0}, data_bus: 0x8A}
      assert CPU.flag(c, :n) == false

      c = TXA.execute(c)
      assert CPU.flag(c, :n) == true
    end

    test "n flag clear" do
      c = %Computer{cpu: %CPU{x: 0x7F, a: 0x88, pc: 0, p: 0b10000000}, data_bus: 0x8A}
      assert CPU.flag(c, :n) == true

      c = TXA.execute(c)
      assert CPU.flag(c, :n) == false
    end
  end
end

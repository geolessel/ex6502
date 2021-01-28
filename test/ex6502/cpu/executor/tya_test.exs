defmodule Ex6502.CPU.Executor.TYATest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper
  alias Ex6502.CPU.Executor.TYA
  alias Ex6502.{Computer, CPU}

  describe "TYA" do
    test "$98" do
      c =
        %Computer{cpu: %CPU{y: 0x99, a: 0x88, pc: 0}, data_bus: 0x98}
        |> TYA.execute()

      assert c.cpu.a == 0x99
      assert c.cpu.pc == 1
    end
  end

  describe "flags" do
    test "z flag set" do
      c = %Computer{cpu: %CPU{y: 0x00, a: 0x88, pc: 0}, data_bus: 0x98}
      assert CPU.flag(c, :z) == false

      c = TYA.execute(c)
      assert CPU.flag(c, :z) == true
    end

    test "z flag clear" do
      c = %Computer{cpu: %CPU{y: 0x99, a: 0x88, pc: 0, p: 0b00000010}, data_bus: 0x98}
      assert CPU.flag(c, :z) == true

      c = TYA.execute(c)
      assert CPU.flag(c, :z) == false
    end

    test "n flag set" do
      c = %Computer{cpu: %CPU{y: 0x90, a: 0x88, pc: 0}, data_bus: 0x98}
      assert CPU.flag(c, :n) == false

      c = TYA.execute(c)
      assert CPU.flag(c, :n) == true
    end

    test "n flag clear" do
      c = %Computer{cpu: %CPU{y: 0x7F, a: 0x88, pc: 0, p: 0b10000000}, data_bus: 0x98}
      assert CPU.flag(c, :n) == true

      c = TYA.execute(c)
      assert CPU.flag(c, :n) == false
    end
  end
end

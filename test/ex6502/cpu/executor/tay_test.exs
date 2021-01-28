defmodule Ex6502.CPU.Executor.TAYTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper
  alias Ex6502.CPU.Executor.TAY
  alias Ex6502.{Computer, CPU}

  describe "TAY" do
    test "$A8" do
      c =
        %Computer{cpu: %CPU{a: 0x99, y: 0x88, pc: 0}, data_bus: 0xA8}
        |> TAY.execute()

      assert c.cpu.y == 0x99
      assert c.cpu.pc == 1
    end
  end

  describe "flags" do
    test "z flag set" do
      c = %Computer{cpu: %CPU{a: 0x00, y: 0x88, pc: 0}, data_bus: 0xA8}
      assert CPU.flag(c, :z) == false

      c = TAY.execute(c)
      assert CPU.flag(c, :z) == true
    end

    test "z flag clear" do
      c = %Computer{cpu: %CPU{a: 0x99, y: 0x88, pc: 0, p: 0b00000010}, data_bus: 0xA8}
      assert CPU.flag(c, :z) == true

      c = TAY.execute(c)
      assert CPU.flag(c, :z) == false
    end

    test "n flag set" do
      c = %Computer{cpu: %CPU{a: 0x90, y: 0x88, pc: 0}, data_bus: 0xA8}
      assert CPU.flag(c, :n) == false

      c = TAY.execute(c)
      assert CPU.flag(c, :n) == true
    end

    test "n flag clear" do
      c = %Computer{cpu: %CPU{a: 0x7F, y: 0x88, pc: 0, p: 0b10000000}, data_bus: 0xA8}
      assert CPU.flag(c, :n) == true

      c = TAY.execute(c)
      assert CPU.flag(c, :n) == false
    end
  end
end

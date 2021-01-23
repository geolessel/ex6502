defmodule Ex6502.CPU.Executor.TAXTest do
  use ExUnit.Case, async: true
  alias Ex6502.CPU.Executor.TAX
  alias Ex6502.{Computer, CPU}

  describe "TAX" do
    test "$AA" do
      c =
        %Computer{cpu: %CPU{a: 0x99, x: 0x88, pc: 0}, data_bus: 0xAA}
        |> TAX.execute()

      assert c.cpu.x == 0x99
      assert c.cpu.pc == 1
    end
  end

  describe "flags" do
    test "z flag set" do
      c = %Computer{cpu: %CPU{a: 0x00, x: 0x88, pc: 0}, data_bus: 0xAA}
      assert CPU.flag(c, :z) == false

      c = TAX.execute(c)
      assert CPU.flag(c, :z) == true
    end

    test "z flag clear" do
      c = %Computer{cpu: %CPU{a: 0x99, x: 0x88, pc: 0, p: 0b00000010}, data_bus: 0xAA}
      assert CPU.flag(c, :z) == true

      c = TAX.execute(c)
      assert CPU.flag(c, :z) == false
    end

    test "n flag set" do
      c = %Computer{cpu: %CPU{a: 0x90, x: 0x88, pc: 0}, data_bus: 0xAA}
      assert CPU.flag(c, :n) == false

      c = TAX.execute(c)
      assert CPU.flag(c, :n) == true
    end

    test "n flag clear" do
      c = %Computer{cpu: %CPU{a: 0x7F, x: 0x88, pc: 0, p: 0b10000000}, data_bus: 0xAA}
      assert CPU.flag(c, :n) == true

      c = TAX.execute(c)
      assert CPU.flag(c, :n) == false
    end
  end
end

defmodule Ex6502.CPU.Executor.TSXTest do
  use ExUnit.Case, async: true

  alias Ex6502.CPU.Executor.TSX
  alias Ex6502.{Computer, CPU}

  describe "TSX" do
    test "$ba" do
      c =
        %Computer{cpu: %CPU{sp: 0x99, x: 0x88, pc: 0}, data_bus: 0xBA}
        |> TSX.execute()

      assert c.cpu.x == 0x99
    end
  end

  describe "flags" do
    test "z flag set" do
      c = %Computer{cpu: %CPU{sp: 0x00, x: 0x88, pc: 0}, data_bus: 0xBA}
      assert CPU.flag(c, :z) == false

      c = TSX.execute(c)
      assert CPU.flag(c, :z) == true
    end

    test "z flag clear" do
      c = %Computer{cpu: %CPU{sp: 0x99, x: 0x88, pc: 0, p: 0b00000010}, data_bus: 0xBA}
      assert CPU.flag(c, :z) == true

      c = TSX.execute(c)
      assert CPU.flag(c, :z) == false
    end

    test "n flag set" do
      c = %Computer{cpu: %CPU{sp: 0x90, x: 0x88, pc: 0}, data_bus: 0xBA}
      assert CPU.flag(c, :n) == false

      c = TSX.execute(c)
      assert CPU.flag(c, :n) == true
    end

    test "n flag clear" do
      c = %Computer{cpu: %CPU{sp: 0x7F, x: 0x88, pc: 0, p: 0b10000000}, data_bus: 0xBA}
      assert CPU.flag(c, :n) == true

      c = TSX.execute(c)
      assert CPU.flag(c, :n) == false
    end
  end
end

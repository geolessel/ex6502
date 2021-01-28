defmodule Ex6502.CPU.Executor.TXSTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.TXS
  alias Ex6502.{Computer, CPU}

  describe "TXS" do
    test "$9a" do
      c =
        %Computer{cpu: %CPU{x: 0x99, sp: 0x88, pc: 0}, data_bus: 0x9A}
        |> TXS.execute()

      assert c.cpu.sp == 0x99
      assert c.cpu.pc == 1
    end
  end
end

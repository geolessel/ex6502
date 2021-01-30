defmodule Ex6502.CPU.Executor.CPXTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.CPX
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "CPX" do
    test "#$nn immediate $E0", %{c: c} do
      c =
        c
        |> setup_computer_for(0xE0)
        |> Computer.load(0x8000, [0xE0, 0x01])
        |> CPU.set(:x, 0x92)
        |> CPX.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == true
    end

    test "$nnnn absolute $EC", %{c: c} do
      c =
        c
        |> setup_computer_for(0xEC)
        |> Computer.load(0x8000, [0xEC, 0x50, 0x80])
        |> Computer.load(0x8050, [0x97])
        |> CPU.set(:x, 0x12)
        |> CPX.execute()

      assert c.cpu.pc == 0x8003
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == false
    end

    test "$nn zero page $E4", %{c: c} do
      c =
        c
        |> setup_computer_for(0xE4)
        |> Computer.load(0x8000, [0xE4, 0x50])
        |> Computer.load(0x0050, [80])
        |> CPU.set(:x, 80)
        |> CPX.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :z) == true
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
    end
  end
end

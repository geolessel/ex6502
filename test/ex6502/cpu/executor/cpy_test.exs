defmodule Ex6502.CPU.Executor.CPYTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper

  alias Ex6502.CPU.Executor.CPY
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "CPY" do
    test "#$nn immediate $C0", %{c: c} do
      c =
        c
        |> setup_computer_for(0xC0)
        |> Computer.load(0x8000, [0xC0, 0x01])
        |> CPU.set(:y, 0x92)
        |> CPY.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :c) == true
    end

    test "$nnnn absolute $CC", %{c: c} do
      c =
        c
        |> setup_computer_for(0xCC)
        |> Computer.load(0x8000, [0xCC, 0x50, 0x80])
        |> Computer.load(0x8050, [0x97])
        |> CPU.set(:y, 0x12)
        |> CPY.execute()

      assert c.cpu.pc == 0x8003
      assert CPU.flag(c, :z) == false
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == false
    end

    test "$nn zero page $C4", %{c: c} do
      c =
        c
        |> setup_computer_for(0xC4)
        |> Computer.load(0x8000, [0xC4, 0x50])
        |> Computer.load(0x0050, [80])
        |> CPU.set(:y, 80)
        |> CPY.execute()

      assert c.cpu.pc == 0x8002
      assert CPU.flag(c, :z) == true
      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :c) == true
    end
  end
end

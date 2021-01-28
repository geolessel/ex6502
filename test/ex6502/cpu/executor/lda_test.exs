defmodule Ex6502.CPU.Executor.LDATest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper
  alias Ex6502.CPU.Executor.LDA
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "LDA" do
    test "$A9 immediate [LDA #$NN]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xA9, 0x53])
        |> setup_computer_for(0xA9)
        |> LDA.execute()

      assert c.cpu.a == 0x53
      assert c.cpu.pc == 0x8002
    end

    test "$AD absolute [LDA $NNNN]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xAD, 0x53, 0xA9])
        |> setup_computer_for(0xAD)
        |> Computer.load(0xA953, [0x99])
        |> LDA.execute()

      assert c.cpu.a == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$BD absolute x-indexed [LDA $NNNN,X]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xBD, 0x53, 0xA9])
        |> setup_computer_for(0xBD)
        |> Computer.load(0xA955, [0x99])
        |> CPU.set(:x, 0x02)
        |> LDA.execute()

      assert c.cpu.a == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$B9 absolute y-indexed [LDA $NNNN,Y]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xB9, 0xF2, 0x33])
        |> setup_computer_for(0xB9)
        |> Computer.load(0x33F9, [0x99])
        |> CPU.set(:y, 0x07)
        |> LDA.execute()

      assert c.cpu.a == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$A5 zero-page [LDA $NN]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xA5, 0x3F])
        |> setup_computer_for(0xA5)
        |> Computer.load(0x3F, [0x99])
        |> LDA.execute()

      assert c.cpu.a == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$B5 zero-page x-indexed [LDA $NN,X]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xB5, 0x30])
        |> setup_computer_for(0xB5)
        |> Computer.load(0x3F, [0x99])
        |> CPU.set(:x, 0x0F)
        |> LDA.execute()

      assert c.cpu.a == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$B2 zero-page indirect [LDA ($NN)]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xB2, 0x30])
        |> setup_computer_for(0xB2)
        |> Computer.load(0x30, [0x50, 0x85])
        |> Computer.load(0x8550, [0x99])
        |> LDA.execute()

      assert c.cpu.a == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$A1 zero-page x-indexed indirect [LDA ($NN,X)]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xA1, 0x30])
        |> setup_computer_for(0xA1)
        |> Computer.load(0x30, [0x05, 0x85])
        |> Computer.load(0x8588, [0x99])
        |> CPU.set(:x, 0x83)
        |> LDA.execute()

      assert c.cpu.a == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$B1 zero-page indirect y-indexed [LDA ($NN),Y]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xB1, 0x01])
        |> setup_computer_for(0xB1)
        |> Computer.load(0x03, [0x50, 0x85])
        |> Computer.load(0x8550, [0x99])
        |> CPU.set(:y, 0x02)
        |> LDA.execute()

      assert c.cpu.a == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "flags", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xA9, 0x7F])
        |> setup_computer_for(0xA9)
        |> LDA.execute()

      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :z) == false

      c =
        c
        |> Computer.load(0x8000, [0xA9, 0x80])
        |> CPU.set(:pc, 0x8000)
        |> setup_computer_for(0xA9)
        |> LDA.execute()

      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :z) == false

      c =
        c
        |> Computer.load(0x8000, [0xA9, 0x00])
        |> CPU.set(:pc, 0x8000)
        |> setup_computer_for(0xA9)
        |> LDA.execute()

      assert CPU.flag(c, :n) == false
      assert CPU.flag(c, :z) == true
    end
  end
end

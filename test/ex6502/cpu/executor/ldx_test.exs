defmodule Ex6502.CPU.Executor.LDXTest do
  use ExUnit.Case, async: true
  import Ex6502.TestHelper
  alias Ex6502.CPU.Executor.LDX
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "LDX" do
    test "$A2 immediate [LDX #$nn]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xA2, 0x99])
        |> setup_computer_for(0xA2)
        |> LDX.execute()

      assert c.cpu.x == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$AE Absolute [LDX $nnnn]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xAE, 0x50, 0x85])
        |> setup_computer_for(0xAE)
        |> Computer.load(0x8550, [0x99])
        |> LDX.execute()

      assert c.cpu.x == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$BE Absolute y-indexed [LDX $nnnn,Y]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xBE, 0x50, 0x85])
        |> setup_computer_for(0xBE)
        |> Computer.load(0x8555, [0x99])
        |> CPU.set(:y, 0x05)
        |> LDX.execute()

      assert c.cpu.x == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$A6 zero-page [LDX $nn]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xA6, 0x50])
        |> setup_computer_for(0xA6)
        |> Computer.load(0x0050, [0x99])
        |> LDX.execute()

      assert c.cpu.x == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$B6 Y-indexed zero-page [LDX $nn,Y]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xB6, 0x50])
        |> setup_computer_for(0xB6)
        |> Computer.load(0x008F, [0x99])
        |> CPU.set(:y, 0x3F)
        |> LDX.execute()

      assert c.cpu.x == 0x99
      assert c.cpu.pc == 0x8002
    end
  end

  describe "flags" do
    test "z flag set", %{c: c} do
      assert CPU.flag(c, :z) == false

      # LDA $8550,Y
      c =
        c
        |> Computer.load(0x8000, [0xBE, 0x50, 0x85])
        |> setup_computer_for(0xBE)
        |> Computer.load(0x8555, [0x00])
        |> CPU.set(:y, 0x05)
        |> LDX.execute()

      assert CPU.flag(c, :z) == true
    end

    test "z flag clear", %{c: c} do
      c =
        c
        |> CPU.set(:a, 0x00)
        |> CPU.set_flags([:z], :a)

      assert CPU.flag(c, :z) == true

      # LDA $8550,Y
      c =
        c
        |> Computer.load(0x8000, [0xBE, 0x50, 0x85])
        |> setup_computer_for(0xBE)
        |> Computer.load(0x8555, [0x99])
        |> CPU.set(:y, 0x05)
        |> LDX.execute()

      assert CPU.flag(c, :z) == false
    end

    test "n flag set", %{c: c} do
      assert CPU.flag(c, :n) == false

      c =
        c
        |> Computer.load(0x8000, [0xA6, 0x50])
        |> setup_computer_for(0xA6)
        |> Computer.load(0x0050, [0x80])
        |> LDX.execute()

      assert CPU.flag(c, :n) == true
    end

    test "n flag clear", %{c: c} do
      c =
        c
        |> CPU.set(:a, 0xFF)
        |> CPU.set_flags([:n], :a)

      assert CPU.flag(c, :n) == true

      c =
        c
        |> Computer.load(0x8000, [0xA6, 0x03])
        |> setup_computer_for(0xA6)
        |> Computer.load(0x0003, [0x7F])
        |> LDX.execute()

      assert CPU.flag(c, :n) == false
    end
  end
end

defmodule Ex6502.CPU.Executor.LDYTest do
  use ExUnit.Case, async: true
  alias Ex6502.CPU.Executor.LDY
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "LDY" do
    test "$A0 immediate [LDY #$nn]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xA0, 0x99])
        |> setup_computer_for(0xA0)
        |> LDY.execute()

      assert c.cpu.y == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$AC absolute [LDY #nnnn]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xAC, 0x50, 0x85])
        |> setup_computer_for(0xAC)
        |> Computer.load(0x8550, [0x99])
        |> LDY.execute()

      assert c.cpu.y == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$BC x-indexed absolute [LDY $nnnn,X]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xBC, 0x50, 0x85])
        |> setup_computer_for(0xBC)
        |> Computer.load(0x8555, [0x99])
        |> CPU.set(:x, 0x05)
        |> LDY.execute()

      assert c.cpu.y == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$A4 zero page [LDY $nn]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xA4, 0x50])
        |> setup_computer_for(0xA4)
        |> Computer.load(0x0050, [0x99])
        |> LDY.execute()

      assert c.cpu.y == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$B4 x-indexed zero page [LDY $nn,X]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0xB4, 0x50])
        |> setup_computer_for(0xB4)
        |> Computer.load(0x008F, [0x99])
        |> CPU.set(:x, 0x3F)
        |> LDY.execute()

      assert c.cpu.y == 0x99
      assert c.cpu.pc == 0x8002
    end
  end

  describe "flags" do
    test "z flag set", %{c: c} do
      assert CPU.flag(c, :z) == false

      c =
        c
        |> Computer.load(0x8000, [0xBC, 0x50, 0x85])
        |> setup_computer_for(0xBC)
        |> Computer.load(0x8555, [0x00])
        |> CPU.set(:x, 0x05)
        |> LDY.execute()

      assert CPU.flag(c, :z) == true
    end

    test "z flag clear", %{c: c} do
      c =
        c
        |> CPU.set(:a, 0x00)
        |> CPU.set_flags([:z], :a)

      assert CPU.flag(c, :z) == true

      c =
        c
        |> Computer.load(0x8000, [0xBC, 0x50, 0x85])
        |> setup_computer_for(0xBC)
        |> Computer.load(0x8555, [0x99])
        |> CPU.set(:x, 0x05)
        |> LDY.execute()

      assert CPU.flag(c, :z) == false
    end

    test "n flag set", %{c: c} do
      assert CPU.flag(c, :n) == false

      c =
        c
        |> Computer.load(0x8000, [0xA4, 0x50])
        |> setup_computer_for(0xA4)
        |> Computer.load(0x0050, [0x80])
        |> LDY.execute()

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
        |> Computer.load(0x8000, [0xA4, 0x03])
        |> setup_computer_for(0xA4)
        |> Computer.load(0x0003, [0x7F])
        |> LDY.execute()

      assert CPU.flag(c, :n) == false
    end
  end

  def setup_computer_for(c, data) do
    c
    |> Map.put(:data_bus, data)
    |> Map.put(:cpu, Map.update(c.cpu, :pc, 0, &(&1 + 1)))
  end
end

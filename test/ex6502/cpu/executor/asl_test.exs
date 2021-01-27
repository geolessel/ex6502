defmodule Ex6502.CPU.Executor.ASLTest do
  use ExUnit.Case, async: true

  alias Ex6502.CPU.Executor.ASL
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "ASL" do
    test "A Accumulator $0A", %{c: c} do
      c =
        c
        |> setup_computer_for(0x0A)
        |> CPU.set(:a, 0b11100101)
        |> Computer.load(0x8000, [0x0A])
        |> ASL.execute()

      assert c.cpu.pc == 0x8001
      assert c.cpu.a == 0b11001010
      assert CPU.flag(c, :c) == true
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :z) == false
    end

    test "$nnnn Absolute $0E", %{c: c} do
      c =
        c
        |> setup_computer_for(0x0E)
        |> Computer.load(0x8000, [0x0E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b01101001])
        |> ASL.execute()

      assert Memory.get(c.memory, 0x9000) == 0b11010010
      assert c.cpu.pc == 0x8003
    end

    test "$nnnn,X X-indexed absolute $1e", %{c: c} do
      c =
        c
        |> setup_computer_for(0x1E)
        |> Computer.load(0x8000, [0x1E, 0x00, 0x90])
        |> Computer.load(0x9005, [0b01101001])
        |> CPU.set(:x, 0x05)
        |> ASL.execute()

      assert Memory.get(c.memory, 0x9005) == 0b11010010
      assert c.cpu.pc == 0x8003
    end

    test "$nn zero page $06", %{c: c} do
      c =
        c
        |> setup_computer_for(0x06)
        |> Computer.load(0x8000, [0x06, 0x90])
        |> Computer.load(0x0090, [0b01101001])
        |> ASL.execute()

      assert Memory.get(c.memory, 0x0090) == 0b11010010
      assert c.cpu.pc == 0x8002
    end

    test "$nn,X x-indexed zero page $16", %{c: c} do
      c =
        c
        |> setup_computer_for(0x16)
        |> Computer.load(0x8000, [0x16, 0x90])
        |> Computer.load(0x0095, [0b01101001])
        |> CPU.set(:x, 0x05)
        |> ASL.execute()

      assert Memory.get(c.memory, 0x0095) == 0b11010010
      assert c.cpu.pc == 0x8002
    end
  end

  describe "flags" do
    test "n flag will be set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x0E)
        |> Computer.load(0x8000, [0x0E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b01101001])
        |> ASL.execute()

      assert CPU.flag(c, :n) == true
    end

    test "n flag will be clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0x0E)
        |> Computer.load(0x8000, [0x0E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b10101001])
        |> ASL.execute()

      assert CPU.flag(c, :n) == false
    end

    test "z flag with be set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x0E)
        |> Computer.load(0x8000, [0x0E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b00000000])
        |> ASL.execute()

      assert CPU.flag(c, :z) == true
    end

    test "z flag with be clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0x0E)
        |> Computer.load(0x8000, [0x0E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b00000001])
        |> ASL.execute()

      assert CPU.flag(c, :z) == false
    end

    test "c flag with be set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x0E)
        |> Computer.load(0x8000, [0x0E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b10000000])
        |> ASL.execute()

      assert CPU.flag(c, :c) == true
    end

    test "c flag with be clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0x0E)
        |> Computer.load(0x8000, [0x0E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b00000000])
        |> ASL.execute()

      assert CPU.flag(c, :c) == false
    end
  end

  def setup_computer_for(c, data) do
    c
    |> Map.put(:data_bus, data)
    |> Map.put(:cpu, Map.update(c.cpu, :pc, 0, &(&1 + 1)))
  end
end

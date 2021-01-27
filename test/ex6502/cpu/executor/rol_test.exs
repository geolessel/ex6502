defmodule Ex6502.CPU.Executor.ROLTest do
  use ExUnit.Case, async: true

  alias Ex6502.CPU.Executor.ROL
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "ROL" do
    test "A Accumulator $2A", %{c: c} do
      c =
        c
        |> setup_computer_for(0x2A)
        |> CPU.set(:a, 0b11100101)
        |> CPU.set_flag(:c, 0)
        |> Computer.load(0x8000, [0x0A])
        |> ROL.execute()

      assert c.cpu.pc == 0x8001
      assert c.cpu.a == 0b11001010
      assert CPU.flag(c, :c) == true
      assert CPU.flag(c, :n) == true
      assert CPU.flag(c, :z) == false
    end

    test "$nnnn Absolute $2E", %{c: c} do
      c =
        c
        |> setup_computer_for(0x2E)
        |> Computer.load(0x8000, [0x2E, 0x00, 0x90])
        |> CPU.set_flag(:c, 1)
        |> Computer.load(0x9000, [0b01101001])
        |> ROL.execute()

      assert Memory.get(c.memory, 0x9000) == 0b11010011
      assert c.cpu.pc == 0x8003
    end

    test "$nnnn,X X-indexed absolute $3E", %{c: c} do
      c =
        c
        |> setup_computer_for(0x3E)
        |> Computer.load(0x8000, [0x3E, 0x00, 0x90])
        |> Computer.load(0x9005, [0b01101001])
        |> CPU.set(:x, 0x05)
        |> ROL.execute()

      assert Memory.get(c.memory, 0x9005) == 0b11010010
      assert c.cpu.pc == 0x8003
    end

    test "$nn zero page $26", %{c: c} do
      c =
        c
        |> setup_computer_for(0x26)
        |> Computer.load(0x8000, [0x26, 0x90])
        |> Computer.load(0x0090, [0b01101001])
        |> ROL.execute()

      assert Memory.get(c.memory, 0x0090) == 0b11010010
      assert c.cpu.pc == 0x8002
    end

    test "$nn,X x-indexed zero page $36", %{c: c} do
      c =
        c
        |> setup_computer_for(0x36)
        |> Computer.load(0x8000, [0x36, 0x90])
        |> Computer.load(0x0095, [0b01101001])
        |> CPU.set(:x, 0x05)
        |> ROL.execute()

      assert Memory.get(c.memory, 0x0095) == 0b11010010
      assert c.cpu.pc == 0x8002
    end
  end

  describe "flags" do
    test "n flag will be set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x2E)
        |> Computer.load(0x8000, [0x2E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b01000000])
        |> ROL.execute()

      assert CPU.flag(c, :n) == true
    end

    test "n flag will be clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0x2E)
        |> Computer.load(0x8000, [0x2E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b10111111])
        |> ROL.execute()

      assert CPU.flag(c, :n) == false
    end

    test "z flag will be set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x2E)
        |> Computer.load(0x8000, [0x2E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b00000000])
        |> ROL.execute()

      assert CPU.flag(c, :z) == true
    end

    test "z flag will be clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0x2E)
        |> Computer.load(0x8000, [0x2E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b00000000])
        |> CPU.set_flag(:c, 1)
        |> ROL.execute()

      assert CPU.flag(c, :z) == false
    end

    test "c flag will be set", %{c: c} do
      c =
        c
        |> setup_computer_for(0x2E)
        |> Computer.load(0x8000, [0x2E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b10000000])
        |> ROL.execute()

      assert CPU.flag(c, :c) == true
    end

    test "c flag will be clear", %{c: c} do
      c =
        c
        |> setup_computer_for(0x2E)
        |> Computer.load(0x8000, [0x2E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b01111111])
        |> ROL.execute()

      assert CPU.flag(c, :c) == false
    end

    test "c flag enters bit 0", %{c: c} do
      c =
        c
        |> setup_computer_for(0x2E)
        |> Computer.load(0x8000, [0x2E, 0x00, 0x90])
        |> Computer.load(0x9000, [0b00000000])
        |> CPU.set_flag(:c, 1)
        |> ROL.execute()

      assert Memory.get(c.memory, 0x9000) == 0b00000001
    end
  end

  def setup_computer_for(c, data) do
    c
    |> Map.put(:data_bus, data)
    |> Map.put(:cpu, Map.update(c.cpu, :pc, 0, &(&1 + 1)))
  end
end

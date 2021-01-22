defmodule Ex6502.MemoryTest do
  use ExUnit.Case, async: true

  alias Ex6502.{Computer, Memory}

  setup do
    c = Computer.init()
    %{c: c}
  end

  describe "initialization" do
    test "creates memory of the correct size" do
      memory = Memory.init(0x80)
      assert 0x80 == length(memory)
    end
  end

  describe "locations" do
    test "loading multiple values at once", %{c: c} do
      values = [0x01, 0x05, 0x90, 0x80, 0xAC, 0xFF]

      m = Memory.load(c.memory, 0x8000, values)

      assert 0x01 == Enum.at(m, 0x8000)
      assert 0x05 == Enum.at(m, 0x8001)
      assert 0x90 == Enum.at(m, 0x8002)
      assert 0x80 == Enum.at(m, 0x8003)
      assert 0xAC == Enum.at(m, 0x8004)
      assert 0xFF == Enum.at(m, 0x8005)
    end

    test "loading multiple values but one is too large", %{c: c} do
      values = [0x01, 0x500, 0x90]

      assert_raise RuntimeError, fn ->
        Memory.load(c.memory, 0x8000, values)
      end
    end

    test "absolute addressing" do
      m =
        Memory.init()
        |> Memory.load(0x5003, [0x99])

      c = %Computer{address_bus: 0x5003, memory: m}

      assert Memory.absolute(c).data_bus == 0x99
    end

    test "indexed absolute addressing" do
      m =
        Memory.init()
        |> Memory.load(0x5003, [0x99])

      c = %Computer{address_bus: 0x5000, memory: m}

      assert Memory.absolute(c, 0x03).data_bus == 0x99
    end
  end
end

defmodule Ex6502.MemoryTest do
  use ExUnit.Case

  alias Ex6502.Memory

  setup do
    Memory.start()
    :ok
  end

  describe "initialization" do
    test "creates memory of the correct size" do
      memory = Memory.dump()
      assert 0xFFFF == length(memory)
    end
  end

  describe "locations" do
    test "setting and getting a single location" do
      assert {:ok, 0x9A} == Memory.set(0x8000, 0x9A)
      assert {:ok, 0x9A} == Memory.get(0x8000)
    end

    test "trying to set a single location with a too-large value" do
      assert {:error, :value_too_large} == Memory.set(0x8000, 0xFF + 1)
    end

    test "loading multiple values at once" do
      values = [0x01, 0x05, 0x90, 0x80, 0xAC, 0xFF]
      assert :ok == Memory.load(0x8000, values)
      assert {:ok, 0x01} == Memory.get(0x8000)
      assert {:ok, 0x05} == Memory.get(0x8001)
      assert {:ok, 0x90} == Memory.get(0x8002)
      assert {:ok, 0x80} == Memory.get(0x8003)
      assert {:ok, 0xAC} == Memory.get(0x8004)
      assert {:ok, 0xFF} == Memory.get(0x8005)
    end

    test "loading multiple values but one is too large" do
      values = [0x01, 0x500, 0x90]
      assert {:error, :value_too_large, 0x500} == Memory.load(0x8000, values)
    end
  end
end

defmodule Ex6502.CPUTest do
  use ExUnit.Case

  alias Ex6502.CPU

  setup do
    CPU.start()
    :ok
  end

  describe "registers" do
    test "getting and setting the state of the a register" do
      assert {:ok, 0x3F} == CPU.set(:a, 0x3F)
      assert 0x3F == CPU.get(:a)
    end

    test "getting and setting the state of the x register" do
      assert {:ok, 0x28} == CPU.set(:x, 0x28)
      assert 0x28 == CPU.get(:x)
    end

    test "getting and setting the state of the y register" do
      assert {:ok, 0xFA} == CPU.set(:y, 0xFA)
      assert 0xFA == CPU.get(:y)
    end

    test "trying to set a value that is too large fails" do
      CPU.set(:a, 0x01)
      assert {:error, :too_large} == CPU.set(:a, 0x89AC)
    end

    test "stepping the program counter" do
      {:ok, _} = CPU.set(:pc, 0x8000)
      assert {:ok, 0x8001} == CPU.step_pc()
      assert {:ok, 0x8004} == CPU.step_pc(3)
    end

    test "trying to step the program counter out of bounds" do
      {:ok, _} = CPU.set(:pc, 0xFFFF)
      assert {:error, :out_of_bounds} == CPU.step_pc()
    end
  end
end

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

    test "advancing the program counter" do
      {:ok, _} = CPU.set(:pc, 0x8000)
      assert {:ok, 0x8001} == CPU.advance_pc()
      assert {:ok, 0x8004} == CPU.advance_pc(3)
    end

    test "trying to advance the program counter out of bounds" do
      {:ok, _} = CPU.set(:pc, 0xFFFF)
      assert {:error, :out_of_bounds} == CPU.advance_pc()
    end
  end

  describe "processor status flags" do
    test "getting and setting the c flag" do
      {:ok, _} = CPU.set_flag(:c, true)
      assert true == CPU.flag(:c)
      {:ok, _} = CPU.set_flag(:c, false)
      assert false == CPU.flag(:c)
    end

    test "getting and setting the z flag" do
      {:ok, _} = CPU.set_flag(:z, true)
      assert true == CPU.flag(:z)
      {:ok, _} = CPU.set_flag(:z, false)
      assert false == CPU.flag(:z)
    end

    test "getting and setting the i flag" do
      {:ok, _} = CPU.set_flag(:i, true)
      assert true == CPU.flag(:i)
      {:ok, _} = CPU.set_flag(:i, false)
      assert false == CPU.flag(:i)
    end

    test "getting and setting the d flag" do
      {:ok, _} = CPU.set_flag(:d, true)
      assert true == CPU.flag(:d)
      {:ok, _} = CPU.set_flag(:d, false)
      assert false == CPU.flag(:d)
    end

    test "getting and setting the b flag" do
      {:ok, _} = CPU.set_flag(:b, true)
      assert true == CPU.flag(:b)
      {:ok, _} = CPU.set_flag(:b, false)
      assert false == CPU.flag(:b)
    end

    test "getting and setting the v flag" do
      {:ok, _} = CPU.set_flag(:v, true)
      assert true == CPU.flag(:v)
      {:ok, _} = CPU.set_flag(:v, false)
      assert false == CPU.flag(:v)
    end

    test "getting and setting the n flag" do
      {:ok, _} = CPU.set_flag(:n, true)
      assert true == CPU.flag(:n)
      {:ok, _} = CPU.set_flag(:n, false)
      assert false == CPU.flag(:n)
    end
  end
end

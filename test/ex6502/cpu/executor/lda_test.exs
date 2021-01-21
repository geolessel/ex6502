defmodule Ex6502.CPU.Executor.LDATest do
  use ExUnit.Case
  alias Ex6502.CPU.Executor.LDA
  alias Ex6502.{CPU, Memory}

  setup do
    Ex6502.CPU.start()
    Ex6502.Memory.start()
    :ok
  end

  describe "LDA" do
    test "$A9 immediate" do
      Memory.load(0x8000, [0xA9, 0x53])
      CPU.set(:pc, 0x8000)
      LDA.execute(Memory.get(0x8000))
      assert 0x53 == CPU.get(:a)
      assert 0x8002 == CPU.get(:pc)
    end

    test "$AD absolute" do
      Memory.load(0x8000, [0xAD, 0x53, 0xA9])
      Memory.set(0xA953, 0x63)
      CPU.set(:pc, 0x8000)
      LDA.execute(Memory.get(0x8000))
      assert 0x63 == CPU.get(:a)
      assert 0x8003 == CPU.get(:pc)
    end

    test "$BD x-indexed absolute" do
      Memory.load(0x8000, [0xBD, 0x53, 0xA9])
      Memory.set(0xA955, 0x9C)
      CPU.set(:pc, 0x8000)
      CPU.set(:x, 0x02)
      LDA.execute(Memory.get(0x8000))
      assert 0x9C == CPU.get(:a)
      assert 0x8003 == CPU.get(:pc)
    end

    test "$B9 y-indexed absolute" do
      Memory.load(0x8000, [0xB9, 0xF2, 0x33])
      Memory.set(0x33F9, 0xCD)
      CPU.set(:pc, 0x8000)
      CPU.set(:y, 0x07)
      LDA.execute(Memory.get(0x8000))
      assert 0xCD == CPU.get(:a)
      assert 0x8003 == CPU.get(:pc)
    end

    test "flags" do
      Memory.load(0x8000, [0xA9, 0x53])
      CPU.set(:pc, 0x8000)
      LDA.execute(Memory.get(0x8000))
      assert CPU.flag(:n) == false
      assert CPU.flag(:z) == false

      Memory.load(0x8000, [0xA9, 0x80])
      CPU.set(:pc, 0x8000)
      LDA.execute(Memory.get(0x8000))
      assert CPU.flag(:n) == true
      assert CPU.flag(:z) == false

      Memory.load(0x8000, [0xA9, 0x00])
      CPU.set(:pc, 0x8000)
      LDA.execute(Memory.get(0x8000))
      assert CPU.flag(:n) == false
      assert CPU.flag(:z) == true
    end
  end
end

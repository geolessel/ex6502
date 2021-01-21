defmodule Ex6502.CPU.ExecutorTest do
  use ExUnit.Case
  alias Ex6502.CPU.Executor
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
      Executor.execute(Memory.get(0x8000))
      assert 0x53 == CPU.get(:a)
      assert 0x8002 == CPU.get(:pc)
    end

    test "$A9 immediate flags" do
      Memory.load(0x8000, [0xA9, 0x53])
      CPU.set(:pc, 0x8000)
      Executor.execute(Memory.get(0x8000))
      assert CPU.flag(:n) == false
      assert CPU.flag(:z) == false

      Memory.load(0x8000, [0xA9, 0x80])
      CPU.set(:pc, 0x8000)
      Executor.execute(Memory.get(0x8000))
      assert CPU.flag(:n) == true
      assert CPU.flag(:z) == false

      Memory.load(0x8000, [0xA9, 0x00])
      CPU.set(:pc, 0x8000)
      Executor.execute(Memory.get(0x8000))
      assert CPU.flag(:n) == false
      assert CPU.flag(:z) == true
    end
  end
end

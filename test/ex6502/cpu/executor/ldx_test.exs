defmodule Ex6502.CPU.Executor.LDXTest do
  use ExUnit.Case
  alias Ex6502.CPU.Executor.LDX
  alias Ex6502.{CPU, Memory}

  setup do
    Ex6502.CPU.start()
    Ex6502.Memory.start()

    CPU.set(:pc, 0x8000)
    :ok
  end

  describe "LDX" do
    test "$A2 immediate [LDX $nn]" do
      Memory.load(0x8000, [0xA2, 0x99])

      CPU.get(:pc)
      |> Memory.get()
      |> LDX.execute()

      assert 0x99 == CPU.get(:x)
      assert 0x8002 == CPU.get(:pc)
    end
  end
end

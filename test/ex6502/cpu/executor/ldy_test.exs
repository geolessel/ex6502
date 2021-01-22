defmodule Ex6502.CPU.Executor.LDYTest do
  use ExUnit.Case
  alias Ex6502.CPU.Executor.LDY
  alias Ex6502.{CPU, Memory}

  setup do
    Ex6502.CPU.start()
    Ex6502.Memory.start()

    CPU.set(:pc, 0x8000)
    :ok
  end

  describe "LDY" do
    test "$A0 immediate [LDY #$nn]" do
      Memory.load(0x8000, [0xA0, 0x99])

      run_cpu()

      assert 0x99 == CPU.get(:y)
      assert 0x8002 == CPU.get(:pc)
    end

    test "$AC absolute [LDY #nnnn]" do
      Memory.load(0x8000, [0xAC, 0x50, 0x85])
      Memory.set(0x8550, 0x99)

      run_cpu()

      assert 0x99 == CPU.get(:y)
      assert 0x8003 == CPU.get(:pc)
    end

    test "$BC x-indexed absolute [LDY $nnnn,X]" do
      Memory.load(0x8000, [0xBC, 0x50, 0x85])
      Memory.set(0x8585, 0x99)
      CPU.set(:x, 0x35)

      run_cpu()

      assert 0x99 == CPU.get(:y)
      assert 0x8003 == CPU.get(:pc)
    end

    test "$A4 zero page [LDY $nn]" do
      Memory.load(0x8000, [0xA4, 0x2D])
      Memory.set(0x2D, 0x99)

      run_cpu()

      assert 0x99 == CPU.get(:y)
      assert 0x8002 == CPU.get(:pc)
    end

    test "$B4 x-indexed zero page [LDY $nn,X]" do
      Memory.load(0x8000, [0xB4, 0x30])
      Memory.set(0x3F, 0x99)
      CPU.set(:x, 0x0F)

      run_cpu()

      assert 0x99 == CPU.get(:y)
      assert 0x8002 == CPU.get(:pc)
    end
  end

  describe "flags" do
    test "z flag set" do
      # LDY $8550,X
      Memory.load(0x8000, [0xBC, 0x50, 0x85])
      Memory.set(0x8558, 0x00)
      CPU.set(:x, 0x08)

      run_cpu()

      assert CPU.flag(:z) == true
    end

    test "z flag clear" do
      # LDY $8550,X
      Memory.load(0x8000, [0xBC, 0x50, 0x85])
      Memory.set(0x8558, 0x90)
      CPU.set(:x, 0x08)

      CPU.set_flag(:z, true)
      assert CPU.flag(:z) == true
      run_cpu()
      assert CPU.flag(:z) == false
    end

    test "n flag set" do
      Memory.load(0x8000, [0xA4, 0x50])
      Memory.set(0x0050, 0x90)

      assert CPU.flag(:n) == false
      run_cpu()
      assert CPU.flag(:n) == true
    end

    test "n flag clear" do
      Memory.load(0x8000, [0xA4, 0x50])
      Memory.set(0x0050, 0x4F)

      CPU.set_flag(:n, true)
      assert CPU.flag(:n) == true
      run_cpu()
      assert CPU.flag(:n) == false
    end
  end

  def run_cpu do
    CPU.get(:pc)
    |> Memory.get()
    |> LDY.execute()
  end
end

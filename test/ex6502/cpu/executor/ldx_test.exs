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
    test "$A2 immediate [LDX #$nn]" do
      Memory.load(0x8000, [0xA2, 0x99])

      run_cpu()

      assert 0x99 == CPU.get(:x)
      assert 0x8002 == CPU.get(:pc)
    end

    test "$AE Absolute [LDX $nnnn]" do
      Memory.load(0x8000, [0xAE, 0x50, 0x85])
      Memory.set(0x8550, 0x99)

      run_cpu()

      assert 0x99 == CPU.get(:x)
      assert 0x8003 == CPU.get(:pc)
    end

    test "$BE Absolute y-indexed [LDX $nnnn,Y]" do
      Memory.load(0x8000, [0xBE, 0x50, 0x85])
      Memory.set(0x8562, 0x99)

      CPU.set(:y, 0x12)

      run_cpu()

      assert 0x99 == CPU.get(:x)
      assert 0x8003 == CPU.get(:pc)
    end

    test "$A6 zero-page [LDX $nn]" do
      Memory.load(0x8000, [0xA6, 0x50])
      Memory.set(0x0050, 0x99)

      run_cpu()

      assert 0x99 == CPU.get(:x)
      assert 0x8002 == CPU.get(:pc)
    end

    test "$B6 Y-indexed zero-page [LDX $nn,Y]" do
      Memory.load(0x8000, [0xB6, 0x50])
      Memory.set(0x008F, 0x99)

      CPU.set(:y, 0x3F)

      run_cpu()

      assert 0x99 == CPU.get(:x)
      assert 0x8002 == CPU.get(:pc)
    end
  end

  describe "flags" do
    test "z flag set" do
      # LDA $8550,Y
      Memory.load(0x8000, [0xBE, 0x50, 0x85])
      Memory.set(0x8558, 0x00)
      CPU.set(:y, 0x08)

      run_cpu()

      assert CPU.flag(:z) == true
    end

    test "z flag clear" do
      # LDA $8550,Y
      Memory.load(0x8000, [0xBE, 0x50, 0x85])
      Memory.set(0x8558, 0x90)
      CPU.set(:y, 0x08)
      CPU.set_flag(:z, true)
      assert CPU.flag(:z) == true

      run_cpu()

      assert CPU.flag(:z) == false
    end

    test "n flag set" do
      Memory.load(0x8000, [0xA6, 0x50])
      Memory.set(0x0050, 0x80)

      assert CPU.flag(:n) == false
      run_cpu()
      assert CPU.flag(:n) == true
    end

    test "n flag clear" do
      Memory.load(0x8000, [0xA6, 0x50])
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
    |> LDX.execute()
  end
end
